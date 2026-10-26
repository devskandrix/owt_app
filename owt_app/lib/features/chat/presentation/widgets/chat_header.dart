import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../models/chat_args.dart';
import '../utils/call_permissions.dart';
import 'chat_avatar.dart';

/// Back chevron, the other person's photo and name, then video and voice
/// call buttons.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, required this.args, required this.showCalls});

  final ChatArgs args;

  /// Whether to show the call buttons. Only true once signed in to
  /// ZEGOCLOUD: the call service starts then, and tapping a call button
  /// before that crashes.
  final bool showCalls;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                Assets.icons.backChevron,
                width: 9,
                height: 18,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ChatAvatar(url: args.avatarUrl, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              args.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.chatHeaderName.copyWith(color: textColor),
            ),
          ),
          if (showCalls) ...[
            _CallButton(args: args, isVideo: true, color: textColor),
            const SizedBox(width: 4),
            _CallButton(args: args, isVideo: false, color: textColor),
          ],
        ],
      ),
    );
  }
}

/// A plain 40x40 icon button that places a voice or video call. Not the
/// call kit's own button: that one sizes and clips its icon in ways the
/// header can't control. The invitation is sent the same way.
class _CallButton extends StatefulWidget {
  const _CallButton({
    required this.args,
    required this.isVideo,
    required this.color,
  });

  final ChatArgs args;
  final bool isVideo;
  final Color color;

  @override
  State<_CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<_CallButton> {
  /// Ignores taps while a call is being started.
  bool _starting = false;

  Future<void> _call() async {
    if (_starting) return;
    _starting = true;
    try {
      // Ask for the microphone (and camera, for video) only now.
      final allowed = await CallPermissions.ensure(
        context,
        video: widget.isVideo,
      );
      if (!allowed) return;
      final sent = await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(widget.args.zegoId, widget.args.name)],
        isVideoCall: widget.isVideo,
        // Matches the offline-call push resource set up in the console.
        resourceID: 'zego_call',
      );
      if (!sent && mounted) {
        TopNotice.showError(context, AppStrings.callFailed);
      }
    } finally {
      _starting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: _call,
        padding: EdgeInsets.zero,
        iconSize: 24,
        tooltip: widget.isVideo
            ? AppStrings.videoCallTooltip
            : AppStrings.voiceCallTooltip,
        icon: Icon(
          widget.isVideo ? Icons.videocam_outlined : Icons.call_outlined,
          color: widget.color,
        ),
      ),
    );
  }
}
