import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../utils/chat_time.dart';
import 'chat_avatar.dart';
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
}

/// One message in the chat, in the design's style: purple bubbles on the
/// right for the user, gray ones on the left for the other person.
///
/// Consecutive messages from the same person are grouped: their photo
/// shows next to the first one, and the time under the last one.
/// Photos, videos and files use ZIMKit's own widget ([defaultWidget]).
class ChatMessageItem extends StatelessWidget {
  const ChatMessageItem({
    super.key,
    required this.message,
    required this.defaultWidget,
    required this.avatarUrl,
    required this.startsGroup,
    required this.endsGroup,
  });

  final ZIMKitMessage message;
  final Widget defaultWidget;

  /// The other person's photo.
  final String? avatarUrl;

  /// First message of a run from the same person.
  final bool startsGroup;

  /// Last message of a run from the same person.
  final bool endsGroup;

  static const double avatarSize = 34;
  static const double _avatarGap = 10;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final text = message.textContent?.text;
    final isText = message.type == ZIMKitMessageType.text && text != null;
    final isVoice =
        message.type == ZIMKitMessageType.audio && message.audioContent != null;
    // Ours: drawn in the design's style, with the photo beside them.
    final custom = isText || isVoice;

    final Widget content;
    if (isText) {
      // Trimmed: a message ending in a line break (Enter before sending)
      // would otherwise show an empty line inside the bubble.
      content = _Bubble(text: text.trim(), mine: mine);
    } else if (isVoice) {
      content = VoiceMessageBubble(message: message);
    } else {
      content = Flexible(child: defaultWidget);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, startsGroup ? 18 : 10, 18, 0),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: mine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!mine && custom) ...[
                if (startsGroup)
                  ChatAvatar(url: avatarUrl, size: avatarSize)
                else
                  const SizedBox(width: avatarSize),
                const SizedBox(width: _avatarGap),
              ],
              content,
            ],
          ),
          if (endsGroup) _TimeLine(message: message, indent: !mine && custom),
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

/// "09:25 AM" under a group, or "Not sent" if sending failed.
class _TimeLine extends StatelessWidget {
  const _TimeLine({required this.message, required this.indent});

  final ZIMKitMessage message;

  /// Lines the time up with the bubble rather than the photo.
  final bool indent;

  @override
  Widget build(BuildContext context) {
    final failed = message.info.error != null;
    final timestamp = message.info.timestamp;
    final label = failed
        ? AppStrings.chatSendFailed
        : timestamp > 0
        ? ChatTime.clock(ChatTime.fromMillis(timestamp))
        : '';
    return Padding(
      padding: EdgeInsets.only(
        top: 7,
        left: indent
            ? ChatMessageItem.avatarSize + ChatMessageItem._avatarGap
            : 0,
      ),
      child: Text(
        label,
        style: failed
            ? AppTextStyles.chatTime.copyWith(color: AppColors.dangerRed)
            : AppTextStyles.chatTime,
      ),
    );
  }
}
