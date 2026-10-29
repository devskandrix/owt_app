import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../domain/entities/chat_message.dart';
import '../utils/chat_time.dart';
import 'chat_avatar.dart';
import 'chat_media_bubble.dart';
import 'voice_message_bubble.dart';

/// Colors of the chat bubbles.
abstract final class ChatColors {
  /// Bubbles the user sent, the camera button and the send button.
  static const Color sent = AppColors.toggleOn;

  /// Bubbles from the other person.
  static Color received(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF202125)
      : const Color(0xFFEFEFF2);

  /// The double tick once a message has been read.
  static const Color readTick = Color(0xFF34B7F1);
}

/// One message in the chat, in the design's style: purple bubbles on the
/// right for the user, gray ones on the left for the other person.
///
/// Consecutive messages from the same person are grouped: their photo
/// shows next to the first one, and the time (plus ticks on the user's
/// own messages) under the last one.
class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.message,
    required this.avatarUrl,
    required this.startsGroup,
    required this.endsGroup,
    required this.onRetry,
  });

  final ChatMessage message;

  /// The other person's photo.
  final String? avatarUrl;

  /// First message of a run from the same person.
  final bool startsGroup;

  /// Last message of a run from the same person.
  final bool endsGroup;

  /// Sends a failed message again.
  final VoidCallback onRetry;

  static const double avatarSize = 34;
  static const double _avatarGap = 10;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final failed = message.sendState == ChatSendState.failed;

    final Widget content = switch (message.type) {
      ChatMessageType.image ||
      ChatMessageType.video => ChatMediaBubble(message: message),
      ChatMessageType.audio => VoiceMessageBubble(message: message),
      // Trimmed: a message ending in a line break would otherwise show an
      // empty line inside the bubble.
      _ => _Bubble(text: (message.content ?? '').trim(), mine: mine),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(20, startsGroup ? 18 : 10, 18, 0),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: failed ? onRetry : null,
            child: Opacity(
              opacity: failed ? 0.6 : 1,
              child: Row(
                mainAxisAlignment: mine
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!mine) ...[
                    if (startsGroup)
                      ChatAvatar(url: avatarUrl, size: avatarSize)
                    else
                      const SizedBox(width: avatarSize),
                    const SizedBox(width: _avatarGap),
                  ],
                  Flexible(child: content),
                ],
              ),
            ),
          ),
          if (endsGroup || failed)
            GestureDetector(
              onTap: failed ? onRetry : null,
              child: _TimeLine(message: message, indent: !mine),
            ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine});

  final String text;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.68;
    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        TopNotice.showSuccess(context, AppStrings.chatCopied);
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: mine ? ChatColors.sent : ChatColors.received(context),
          // Pill-shaped on one line, still rounded when it wraps.
          borderRadius: BorderRadius.circular(19),
        ),
        child: Text(
          text,
          style: AppTextStyles.chatBubble.copyWith(
            color: mine ? Colors.white : context.appColors.textPrimary,
          ),
          // Fixed line height: characters Outfit lacks (e.g. Hindi) fall
          // back to a system font with taller lines, which would otherwise
          // stretch the bubble.
          strutStyle: const StrutStyle(
            fontFamily: 'Outfit',
            fontSize: 15,
            height: 1.3,
            forceStrutHeight: true,
          ),
        ),
      ),
    );
  }
}

/// "09:25 AM" under a group, with ticks on the user's own messages, or
/// "Not sent · Tap to retry" if sending failed.
class _TimeLine extends StatelessWidget {
  const _TimeLine({required this.message, required this.indent});

  final ChatMessage message;

  /// Lines the time up with the bubble rather than the photo.
  final bool indent;

  @override
  Widget build(BuildContext context) {
    final failed = message.sendState == ChatSendState.failed;
    return Padding(
      padding: EdgeInsets.only(
        top: 7,
        left: indent
            ? ChatMessageItem.avatarSize + ChatMessageItem._avatarGap
            : 0,
      ),
      child: failed
          ? Text(
              AppStrings.chatSendFailed,
              style: AppTextStyles.chatTime.copyWith(
                color: AppColors.dangerRed,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ChatTime.clock(message.createdAt),
                  style: AppTextStyles.chatTime,
                ),
                if (message.isMine) ...[
                  const SizedBox(width: 4),
                  _Ticks(message: message),
                ],
              ],
            ),
    );
  }
}

/// Clock while sending; one tick when sent; gray double tick once
/// delivered. Read receipts (blue) are hidden for now: a read message
/// shows the same gray double tick. Set [_showReadReceipts] to bring
/// them back.
class _Ticks extends StatelessWidget {
  const _Ticks({required this.message});

  final ChatMessage message;

  static const bool _showReadReceipts = false;

  @override
  Widget build(BuildContext context) {
    final gray = AppTextStyles.chatTime.color ?? context.appColors.textMuted;
    if (message.sendState == ChatSendState.sending) {
      return Icon(Icons.schedule_rounded, size: 13, color: gray);
    }
    return switch (message.ticks) {
      ChatTicks.single => Icon(Icons.done_rounded, size: 15, color: gray),
      ChatTicks.delivered => Icon(
        Icons.done_all_rounded,
        size: 15,
        color: gray,
      ),
      ChatTicks.read => Icon(
        Icons.done_all_rounded,
        size: 15,
        color: _showReadReceipts ? ChatColors.readTick : gray,
      ),
    };
  }
}
