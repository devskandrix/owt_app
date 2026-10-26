import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../core/services/zego_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'chat_message_item.dart';

/// The rounded bar at the bottom of the chat: a purple camera button
/// (send photos/videos), the text field, and the hold-to-record mic.
/// The send button replaces the empty space next to the mic while typing.
///
/// Wraps ZIMKit's [ZIMKitMessageInput] so sending, uploads and voice
/// recording keep working; only its look changes.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.conversationId,
    required this.recordStatus,
    required this.listScrollController,
  });

  final String conversationId;
  final ZIMKitRecordStatus recordStatus;
  final ScrollController listScrollController;

  /// Size of ZIMKit's mic (record) and send buttons. ZIMKit reads this
  /// from one global setting that defaults to 32, which is too big here.
  /// The camera button sizes itself (see [_CameraButton]), so it isn't
  /// affected.
  static const double _actionIconSize = 24;

  @override
  Widget build(BuildContext context) {
    ZIMKitMessageStyle.iconSize = _actionIconSize;
    final colors = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
        child: Container(
          // 52px tall with the 42px camera circle inset 5px, as in the
          // design.
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.fromLTRB(5, 5, 14, 5),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1C1D21) : const Color(0xFFF1F1F4),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            // Keeps the camera at the bottom when the text wraps.
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Outside ZIMKit's input: it boxes its own actions to the
              // small mic size, which would shrink this button.
              _CameraButton(conversationId: conversationId),
              const SizedBox(width: 8),
              Expanded(
                // ZIMKit's input adds its own SafeArea; the outer one
                // already covers the home indicator.
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                  child: ZIMKitMessageInput(
                    conversationID: conversationId,
                    recordStatus: recordStatus,
                    listScrollController: listScrollController,
                    containerPadding: EdgeInsets.zero,
                    containerDecoration: const BoxDecoration(),
                    inputBackgroundDecoration: const BoxDecoration(),
                    showMoreButton: false,
                    showPickFileButton: false,
                    showPickMediaButton: false,
                    maxLines: 4,
                    onMessageSent: (message) => ZegoService.log(
                      'chat $conversationId: sent ${message.type.name} message, '
                      '${message.info.sentStatus.name}'
                      '${message.info.error == null ? '' : ' (${message.info.error!.code}: ${message.info.error!.message})'}',
                    ),
                    actions: [
                      // Keeps ZIMKit from showing a disabled send button while
                      // the field is empty.
                      ZIMKitMessageInputAction.rightInside(
                        const SizedBox.shrink(),
                      ),
                    ],
                    inputDecoration: InputDecoration.collapsed(
                      hintText: AppStrings.chatInputHint,
                      hintStyle: AppTextStyles.chatBubble.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                    sendButtonWidget: const Icon(
                      Icons.send_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton({required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context) {
    return ZIMKitPickMediaButton(
      onFilePicked: (files) {
        if (files.isEmpty) return;
        ZIMKit().sendMediaMessage(
          conversationId,
          ZIMKitConversationType.peer,
          files,
        );
      },
      icon: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: ChatColors.sent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
      ),
    );
  }
}
