import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/chat_event.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

enum ChatRoomStatus { loading, loaded, failure }

class ChatRoomState extends Equatable {
  final ChatRoomStatus status;

  /// Oldest first.
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool loadingMore;

  /// Whether the other person is typing right now.
  final bool otherTyping;
  final String? errorMessage;

  const ChatRoomState({
    this.status = ChatRoomStatus.loading,
    this.messages = const [],
    this.hasMore = false,
    this.loadingMore = false,
    this.otherTyping = false,
    this.errorMessage,
  });

  ChatRoomState copyWith({
    ChatRoomStatus? status,
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? loadingMore,
    bool? otherTyping,
    String? errorMessage,
  }) => ChatRoomState(
    status: status ?? this.status,
    messages: messages ?? this.messages,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    otherTyping: otherTyping ?? this.otherTyping,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    messages,
    hasMore,
    loadingMore,
    otherTyping,
    errorMessage,
  ];
}

/// One open chat. Loads history 50 at a time (older pages by `before`),
/// applies live socket updates for this match, sends optimistically
/// (shown at once, replaced by the server's copy when it returns), sends
/// typing start / stop, and marks the chat read while it's on screen.
class ChatRoomCubit extends Cubit<ChatRoomState> with WidgetsBindingObserver {
  ChatRoomCubit(this._repository, {required this.matchId})
    : super(const ChatRoomState()) {
    _events = _repository.events.listen(_onEvent);
    _reconnects = _repository.reconnects.listen((_) => _catchUp());
    WidgetsBinding.instance.addObserver(this);
    load();
  }

  final ChatRepository _repository;
  final String matchId;

  late final StreamSubscription<ChatEvent> _events;
  late final StreamSubscription<void> _reconnects;

  static const int _pageSize = 50;
  static const Duration _typingIdle = Duration(milliseconds: 2500);

  /// Clears a stuck "typing…" if its `typing:stop` never arrives.
  static const Duration _typingTimeout = Duration(seconds: 8);

  Timer? _typingStopTimer;
  Timer? _otherTypingTimer;
  bool _typing = false;
  int _localCounter = 0;
  bool _foreground = true;

  Future<void> load() async {
    emit(const ChatRoomState());
    try {
      final messages = await _repository.getMessages(matchId, limit: _pageSize);
      if (isClosed) return;
      emit(
        ChatRoomState(
          status: ChatRoomStatus.loaded,
          messages: messages,
          hasMore: messages.length >= _pageSize,
        ),
      );
      _markRead();
    } on Failure catch (f) {
      _fail(f.message);
    } catch (_) {
      _fail(AppStrings.somethingWentWrong);
    }
  }

  /// Loads the page before the oldest message shown.
  Future<void> loadOlder() async {
    if (!state.hasMore || state.loadingMore || state.messages.isEmpty) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final older = await _repository.getMessages(
        matchId,
        limit: _pageSize,
        before: state.messages.first.createdAt,
      );
      if (isClosed) return;
      final known = {for (final m in state.messages) m.id};
      emit(
        state.copyWith(
          messages: [
            ...older.where((m) => !known.contains(m.id)),
            ...state.messages,
          ],
          hasMore: older.length >= _pageSize,
          loadingMore: false,
        ),
      );
    } catch (_) {
      if (!isClosed) emit(state.copyWith(loadingMore: false));
    }
  }

  // -------------------------------------------------------------------
  // Sending
  // -------------------------------------------------------------------

  Future<void> sendText(String text) async {
    final content = text.trim();
    if (content.isEmpty) return;
    _stopTyping();
    final local = _localMessage(ChatMessageType.text, content: content);
    _add(local);
    await _deliver(local, () => _repository.sendText(matchId, content));
  }

  Future<void> sendMedia(
    File file,
    ChatMessageType type, {
    int? durationSeconds,
  }) async {
    final local = _localMessage(
      type,
      localFilePath: file.path,
      durationSeconds: durationSeconds,
    );
    _add(local);
    await _deliver(
      local,
      () => _repository.sendMedia(
        matchId,
        file,
        durationSeconds: durationSeconds,
      ),
    );
  }

  /// Sends a failed message again.
  Future<void> retry(ChatMessage message) async {
    if (message.sendState != ChatSendState.failed) return;
    _replace(
      message.localId!,
      message.copyWith(sendState: ChatSendState.sending),
    );
    final path = message.localFilePath;
    await _deliver(
      message,
      () => path != null
          ? _repository.sendMedia(
              matchId,
              File(path),
              durationSeconds: message.durationSeconds,
            )
          : _repository.sendText(matchId, message.content ?? ''),
    );
  }

  Future<void> _deliver(
    ChatMessage local,
    Future<ChatMessage> Function() send,
  ) async {
    try {
      final sent = await send();
      if (isClosed) return;
      // The socket echo may have added it already.
      if (state.messages.any((m) => m.id == sent.id)) {
        _remove(local.localId!);
      } else {
        _replace(local.localId!, _keepLocalFile(sent, local));
      }
    } catch (_) {
      if (isClosed) return;
      _replace(local.localId!, local.copyWith(sendState: ChatSendState.failed));
    }
  }

  ChatMessage _localMessage(
    ChatMessageType type, {
    String? content,
    String? localFilePath,
    int? durationSeconds,
  }) => ChatMessage(
    id: '',
    matchId: matchId,
    senderId: '',
    isMine: true,
    type: type,
    content: content,
    localFilePath: localFilePath,
    durationSeconds: durationSeconds,
    createdAt: DateTime.now(),
    localId:
        'local-${DateTime.now().microsecondsSinceEpoch}-${_localCounter++}',
    sendState: ChatSendState.sending,
  );

  /// The server's copy, keeping the local file so a just-sent photo or
  /// voice note doesn't have to download again.
  static ChatMessage _keepLocalFile(ChatMessage sent, ChatMessage local) =>
      local.localFilePath == null
      ? sent
      : ChatMessage(
          id: sent.id,
          matchId: sent.matchId,
          senderId: sent.senderId,
          isMine: true,
          type: sent.type == ChatMessageType.unknown ? local.type : sent.type,
          content: sent.content,
          mediaUrl: sent.mediaUrl,
          durationSeconds: sent.durationSeconds ?? local.durationSeconds,
          createdAt: sent.createdAt,
          deliveredAt: sent.deliveredAt,
          readAt: sent.readAt,
          localFilePath: local.localFilePath,
        );

  // -------------------------------------------------------------------
  // Typing
  // -------------------------------------------------------------------

  /// Call on every change to the input: sends `typing:start` once, then
  /// `typing:stop` after a short pause.
  void inputChanged(String text) {
    if (text.trim().isEmpty) {
      _stopTyping();
      return;
    }
    if (!_typing) {
      _typing = true;
      _repository.sendTyping(matchId, typing: true);
    }
    _typingStopTimer?.cancel();
    _typingStopTimer = Timer(_typingIdle, _stopTyping);
  }

  void _stopTyping() {
    _typingStopTimer?.cancel();
    if (!_typing) return;
    _typing = false;
    _repository.sendTyping(matchId, typing: false);
  }

  // -------------------------------------------------------------------
  // Live updates
  // -------------------------------------------------------------------

  void _onEvent(ChatEvent event) {
    if (isClosed) return;
    switch (event) {
      case ChatMessageReceived(:final message) when message.matchId == matchId:
        _received(message);
      case ChatMessagesDelivered(:final matchId, :final messageIds, :final at)
          when matchId == null || matchId == this.matchId:
        _updateMine(
          (m) =>
              m.deliveredAt == null &&
              (messageIds.isEmpty
                  ? !m.createdAt.isAfter(at)
                  : messageIds.contains(m.id)),
          (m) => m.copyWith(deliveredAt: at),
        );
      // Ticks only change when the other person reads; a read from the
      // user's own other device is ignored here.
      case ChatMessagesRead(
            :final matchId,
            :final messageIds,
            :final at,
            :final byMe,
          )
          when matchId == this.matchId && !byMe:
        _updateMine(
          (m) =>
              m.readAt == null &&
              (messageIds.isEmpty
                  ? !m.createdAt.isAfter(at)
                  : messageIds.contains(m.id)),
          (m) => m.copyWith(readAt: at, deliveredAt: m.deliveredAt ?? at),
        );
      case ChatTypingChanged(:final matchId, :final typing)
          when matchId == this.matchId:
        _otherTypingTimer?.cancel();
        if (typing) {
          _otherTypingTimer = Timer(_typingTimeout, () {
            if (!isClosed) emit(state.copyWith(otherTyping: false));
          });
        }
        emit(state.copyWith(otherTyping: typing));
      default:
        break;
    }
  }

  void _received(ChatMessage message) {
    if (state.messages.any((m) => m.id == message.id)) return;
    if (message.isMine) {
      // Our own message coming back over the socket before its POST
      // returned: replace the pending copy instead of showing it twice.
      final pending = state.messages.where(
        (m) =>
            m.sendState == ChatSendState.sending &&
            m.type == message.type &&
            (m.type != ChatMessageType.text || m.content == message.content),
      );
      if (pending.isNotEmpty) {
        _replace(
          pending.first.localId!,
          _keepLocalFile(message, pending.first),
        );
        return;
      }
    }
    _add(message);
    if (!message.isMine) {
      // Their message ends their typing.
      _otherTypingTimer?.cancel();
      if (state.otherTyping) emit(state.copyWith(otherTyping: false));
      _markRead();
    }
  }

  /// A reconnect may have missed messages: fetch the latest page and merge.
  Future<void> _catchUp() async {
    if (state.status != ChatRoomStatus.loaded) return;
    try {
      final latest = await _repository.getMessages(matchId, limit: _pageSize);
      if (isClosed) return;
      final byId = {for (final m in latest) m.id: m};
      final merged = [
        for (final m in state.messages) byId.remove(m.id) ?? m,
        ...byId.values,
      ]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      emit(state.copyWith(messages: merged));
      _markRead();
    } catch (_) {}
  }

  void _markRead() {
    if (!_foreground) return;
    final hasUnread = state.messages.any((m) => !m.isMine && m.readAt == null);
    if (!hasUnread) return;
    _repository.markRead(matchId).catchError((_) {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) {
      _markRead();
    } else {
      _stopTyping();
    }
  }

  // -------------------------------------------------------------------

  void _add(ChatMessage message) {
    emit(
      state.copyWith(
        messages: [...state.messages, message]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      ),
    );
  }

  void _replace(String localId, ChatMessage message) {
    emit(
      state.copyWith(
        messages: [
          for (final m in state.messages) m.localId == localId ? message : m,
        ],
      ),
    );
  }

  void _remove(String localId) {
    emit(
      state.copyWith(
        messages: state.messages.where((m) => m.localId != localId).toList(),
      ),
    );
  }

  void _updateMine(
    bool Function(ChatMessage) where,
    ChatMessage Function(ChatMessage) change,
  ) {
    var changed = false;
    final updated = [
      for (final m in state.messages)
        if (m.isMine && m.id.isNotEmpty && where(m))
          (() {
            changed = true;
            return change(m);
          })()
        else
          m,
    ];
    if (changed) emit(state.copyWith(messages: updated));
  }

  void _fail(String message) {
    if (isClosed) return;
    emit(ChatRoomState(status: ChatRoomStatus.failure, errorMessage: message));
  }

  @override
  Future<void> close() {
    _stopTyping();
    _otherTypingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _events.cancel();
    _reconnects.cancel();
    return super.close();
  }
}
