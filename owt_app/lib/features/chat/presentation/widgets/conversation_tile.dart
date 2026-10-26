import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../utils/chat_time.dart';
import 'chat_avatar.dart';

/// One row on the Messages screen: photo, name, a preview line, and a
/// purple dot when there are unread messages. Only chats that have
/// messages are listed, so [lastMessage] is always set.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.onTap,
    required this.conversation,
    required this.lastMessage,
  });

  final String name;
  final String? avatarUrl;
  final ZIMKitConversation conversation;
  final ZIMKitMessage lastMessage;
  final VoidCallback onTap;

  /// Purple used for the unread dot and sent chat bubbles.
  static const Color unreadDot = AppColors.toggleOn;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final unread = conversation.unreadMessageCount;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Row(
          children: [
            ChatAvatar(url: avatarUrl, size: 62),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.conversationName.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _PreviewLine(message: lastMessage, unread: unread),
                ],
              ),
            ),
            if (unread > 0) ...[
              const SizedBox(width: 12),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: unreadDot,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "4 New Message • 4h" when unread, otherwise the last message itself
/// ("You: See you there • 2d").
class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.message, required this.unread});

  final ZIMKitMessage message;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasUnread = unread > 0;
    final text = hasUnread
        ? '$unread ${AppStrings.chatNewMessages}'
        : '${message.isMine ? AppStrings.chatYouPrefix : ''}'
              '${_describe(message)}';
    final style = AppTextStyles.conversationPreview.copyWith(
      color: hasUnread ? colors.textPrimary : colors.textMuted,
    );
    final time = message.info.timestamp > 0
        ? ChatTime.ago(ChatTime.fromMillis(message.info.timestamp))
        : null;

    return Row(
      children: [
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        if (time != null) Text('  •  $time', style: style),
      ],
    );
  }

  static String _describe(ZIMKitMessage message) {
    switch (message.type) {
      case ZIMKitMessageType.text:
        return message.textContent?.text.replaceAll('\n', ' ') ?? '';
      case ZIMKitMessageType.image:
        return AppStrings.chatPhoto;
      case ZIMKitMessageType.video:
        return AppStrings.chatVideo;
      case ZIMKitMessageType.audio:
        return AppStrings.chatVoiceMessage;
      case ZIMKitMessageType.file:
        return AppStrings.chatFile;
      default:
        return '';
    }
  }
}
