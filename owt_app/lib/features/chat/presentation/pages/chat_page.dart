import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../core/services/zego_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/chat_args.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_item.dart';
import '../widgets/chat_unavailable.dart';

/// A 1-to-1 chat (ZEGOCLOUD ZIMKit) with a matched user, with video and
/// voice call buttons in the header.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.args});

  final ChatArgs args;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Future<void> _ready = ZegoService.login();

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    // ZIMKit's own widgets (photo/voice messages, send button) take their
    // accent from primaryColor.
    final theme = Theme.of(context).copyWith(primaryColor: ChatColors.sent);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: context.appColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FutureBuilder<void>(
                future: _ready,
                builder: (context, snapshot) => ChatHeader(
                  args: args,
                  showCalls:
                      snapshot.connectionState == ConnectionState.done &&
                      ZegoService.isLoggedIn,
                ),
              ),
              Expanded(
                child: !ZegoService.isAvailable
                    ? const ChatUnavailable()
                    : FutureBuilder<void>(
                        future: _ready,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // Chat widgets query ZEGOCLOUD straight away, so
                          // only build them once signed in.
                          if (!ZegoService.isLoggedIn) {
                            return const ChatUnavailable();
                          }
                          return _ChatBody(args: args, theme: theme);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The message list and input bar, built once signed in to ZEGOCLOUD.
class _ChatBody extends StatefulWidget {
  const _ChatBody({required this.args, required this.theme});

  final ChatArgs args;
  final ThemeData theme;

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final _recordStatus = ZIMKitRecordStatus();
  final _scrollController = ScrollController();

  /// The same list ZIMKit shows; read to group messages by sender.
  ZIMKitMessageListNotifier? _messages;

  /// Messages further apart than this start a new group (new time label).
  static const _groupGap = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _recordStatus.register();
    ZIMKit()
        .getMessageListNotifier(widget.args.zegoId, ZIMKitConversationType.peer)
        .then((list) {
          if (mounted) setState(() => _messages = list);
        })
        // Only used for grouping; without it every message shows its own
        // photo and time. ZIMKit's list shows its own error state.
        .catchError((Object e) {
          ZegoService.log(
            'chat ${widget.args.zegoId}: loading messages failed: $e',
          );
          return null;
        });
  }

  @override
  void dispose() {
    _recordStatus.unregister();
    _scrollController.dispose();
    super.dispose();
  }

  bool _sameGroup(ZIMKitMessage a, ZIMKitMessage b) {
    if (a.isMine != b.isMine) return false;
    final ta = a.info.timestamp;
    final tb = b.info.timestamp;
    // A message still sending may not have a timestamp yet.
    if (ta == 0 || tb == 0) return true;
    return (ta - tb).abs() < _groupGap.inMilliseconds;
  }

  Widget _buildItem(
    BuildContext context,
    ZIMKitMessage message,
    Widget defaultWidget,
  ) {
    final list = _messages?.value ?? const [];
    final i = list.indexWhere((n) => identical(n.value, message));
    final startsGroup = i <= 0 || !_sameGroup(list[i - 1].value, message);
    final endsGroup =
        i < 0 ||
        i == list.length - 1 ||
        !_sameGroup(list[i + 1].value, message);
    return ChatMessageItem(
      message: message,
      defaultWidget: defaultWidget,
      avatarUrl: widget.args.avatarUrl,
      startsGroup: startsGroup,
      endsGroup: endsGroup,
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversationId = widget.args.zegoId;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ZIMKitMessageListView(
                conversationID: conversationId,
                scrollController: _scrollController,
                theme: widget.theme,
                itemBuilder: _buildItem,
              ),
            ),
            ChatInputBar(
              conversationId: conversationId,
              recordStatus: _recordStatus,
              listScrollController: _scrollController,
            ),
          ],
        ),
        // "Slide up to lock" target shown above the mic while recording.
        Positioned(
          right: 22,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 84,
          child: SizedBox(
            width: ZIMKitRecordStyle.lockerIconSize,
            height: ZIMKitRecordStyle.lockerIconSize,
            child: ZIMKitRecordLocker(processor: _recordStatus),
          ),
        ),
      ],
    );
  }
}
