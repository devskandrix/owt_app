import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_event.dart';
import '../../domain/repositories/chat_repository.dart';

enum ChatListStatus { loading, loaded, failure }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ChatConversation> conversations;
  final String? errorMessage;

  const ChatListState({
    this.status = ChatListStatus.loading,
    this.conversations = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, conversations, errorMessage];
}

/// The Messages inbox (`GET /chats`), kept live over the socket: a new
/// message moves its chat to the top and bumps the unread count (not for
/// the user's own messages sent from another device), and reading a chat
/// on another device clears its unread count.
class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit(this._repository) : super(const ChatListState()) {
    _events = _repository.events.listen(_onEvent);
    _reconnects = _repository.reconnects.listen((_) => load(silent: true));
    load();
  }

  final ChatRepository _repository;
  late final StreamSubscription<ChatEvent> _events;
  late final StreamSubscription<void> _reconnects;

  /// Loads the inbox. [silent] keeps the current list on screen (used for
  /// refreshes) instead of showing a spinner.
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const ChatListState());
    try {
      final conversations = await _repository.getConversations();
      if (isClosed) return;
      emit(
        ChatListState(
          status: ChatListStatus.loaded,
          conversations: _sorted(conversations),
        ),
      );
    } on Failure catch (f) {
      if (!silent) _fail(f.message);
    } catch (_) {
      if (!silent) _fail(AppStrings.somethingWentWrong);
    }
  }

  /// The user opened [matchId]: its unread count is now 0.
  void opened(String matchId) {
    _update(matchId, (c) => c.copyWith(unreadCount: 0));
  }

  void _onEvent(ChatEvent event) {
    if (isClosed) return;
    // Read on another of the user's devices: clear that chat's dot here.
    if (event is ChatMessagesRead && event.byMe) {
      opened(event.matchId);
      return;
    }
    if (event is! ChatMessageReceived) return;
    final message = event.message;
    final known = state.conversations.any((c) => c.matchId == message.matchId);
    // A chat that just started: reload to get who it's with.
    if (!known) {
      load(silent: true);
      return;
    }
    _update(
      message.matchId,
      (c) => c.copyWith(
        lastMessage: message,
        unreadCount: message.isMine ? c.unreadCount : c.unreadCount + 1,
      ),
    );
  }

  void _update(
    String matchId,
    ChatConversation Function(ChatConversation) change,
  ) {
    if (isClosed) return;
    final updated = [
      for (final c in state.conversations) c.matchId == matchId ? change(c) : c,
    ];
    emit(ChatListState(status: state.status, conversations: _sorted(updated)));
  }

  static List<ChatConversation> _sorted(List<ChatConversation> list) {
    final sorted = [...list];
    sorted.sort((a, b) {
      final ta = a.lastActivity;
      final tb = b.lastActivity;
      if (ta == null && tb == null) return 0;
      if (ta == null) return 1;
      if (tb == null) return -1;
      return tb.compareTo(ta);
    });
    return sorted;
  }

  void _fail(String message) {
    if (isClosed) return;
    emit(ChatListState(status: ChatListStatus.failure, errorMessage: message));
  }

  @override
  Future<void> close() {
    _events.cancel();
    _reconnects.cancel();
    return super.close();
  }
}
