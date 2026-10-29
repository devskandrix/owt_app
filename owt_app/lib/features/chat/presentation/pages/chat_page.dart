import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/services/chat_socket_service.dart';
import '../../../../core/services/zego_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chat_message.dart';
import '../cubit/chat_room_cubit.dart';
import '../models/chat_args.dart';
import '../utils/chat_time.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_item.dart';
import '../widgets/chat_unavailable.dart';

/// A 1-to-1 chat with a matched user. Messages go over our backend (REST +
/// Socket.IO, see [ChatRoomCubit]); the header's voice and video call
/// buttons use ZEGOCLOUD.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.args});

  final ChatArgs args;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  /// Calls need the ZEGOCLOUD call service, started at sign-in.
  late final Future<void> _callsReady = ZegoService.login();

  @override
  void initState() {
    super.initState();
    // Normally already connected from Home.
    ChatSocketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    return BlocProvider(
      create: (_) => ChatRoomCubit(sl(), matchId: args.matchId),
      child: Scaffold(
        backgroundColor: context.appColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FutureBuilder<void>(
                future: _callsReady,
                builder: (context, snapshot) =>
                    BlocSelector<ChatRoomCubit, ChatRoomState, bool>(
                      selector: (state) => state.otherTyping,
                      builder: (context, typing) => ChatHeader(
                        args: args,
                        typing: typing,
                        showCalls:
                            snapshot.connectionState == ConnectionState.done &&
                            ZegoService.isLoggedIn,
                      ),
                    ),
              ),
              Expanded(child: _ChatBody(args: args)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBody extends StatefulWidget {
  const _ChatBody({required this.args});

  final ChatArgs args;

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final _scrollController = ScrollController();

  /// Messages further apart than this start a new group (new time label).
  static const _groupGap = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// The list is reversed, so the oldest messages are at the max extent.
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      context.read<ChatRoomCubit>().loadOlder();
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  bool _sameGroup(ChatMessage a, ChatMessage b) =>
      a.isMine == b.isMine &&
      ChatTime.sameDay(a.createdAt, b.createdAt) &&
      a.createdAt.difference(b.createdAt).abs() < _groupGap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatRoomCubit>();
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
            builder: (context, state) {
              if (state.status == ChatRoomStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == ChatRoomStatus.failure) {
                return GestureDetector(
                  onTap: cubit.load,
                  child: ChatUnavailable(
                    message:
                        '${state.errorMessage ?? AppStrings.chatLoadFailed}\n'
                        '${AppStrings.retryLabel}',
                  ),
                );
              }
              final messages = state.messages;
              // Reversed list: index 0 is the newest message.
              final count = messages.length + (state.loadingMore ? 1 : 0);
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: count,
                itemBuilder: (context, index) {
                  if (index >= messages.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  final i = messages.length - 1 - index;
                  final message = messages[i];
                  final previous = i > 0 ? messages[i - 1] : null;
                  final next = i < messages.length - 1 ? messages[i + 1] : null;
                  final newDay =
                      previous == null ||
                      !ChatTime.sameDay(previous.createdAt, message.createdAt);
                  return Column(
                    key: ValueKey(message.key),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (newDay) _DateHeader(date: message.createdAt),
                      ChatMessageItem(
                        message: message,
                        avatarUrl: widget.args.avatarUrl,
                        startsGroup: newDay || !_sameGroup(previous, message),
                        endsGroup: next == null || !_sameGroup(next, message),
                        onRetry: () => cubit.retry(message),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        ChatInputBar(
          onTextChanged: cubit.inputChanged,
          onSendText: (text) {
            cubit.sendText(text);
            _scrollToBottom();
          },
          onSendMedia: (file, type, {durationSeconds}) {
            cubit.sendMedia(file, type, durationSeconds: durationSeconds);
            _scrollToBottom();
          },
        ),
      ],
    );
  }
}

/// "Today" / "Yesterday" / "12 Oct 2026" between days.
class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 2),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: ChatColors.received(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(ChatTime.dateLabel(date), style: AppTextStyles.chatTime),
        ),
      ),
    );
  }
}
