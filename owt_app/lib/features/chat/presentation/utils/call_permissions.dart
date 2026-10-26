import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/widgets/top_notice.dart';

/// Asks for what a call needs, right when the user starts one: the
/// microphone for a voice call, the camera and microphone for a video
/// call. Returns false (and explains why) if anything needed is refused,
/// so the call isn't placed.
abstract final class CallPermissions {
  static Future<bool> ensure(
    BuildContext context, {
    required bool video,
  }) async {
    final needed = [Permission.microphone, if (video) Permission.camera];
    final statuses = await needed.request();
    final refused = [
      for (final permission in needed)
        if (!(statuses[permission]?.isGranted ?? false)) permission,
    ];
    if (refused.isEmpty) return true;
    if (!context.mounted) return false;

    final blocked = refused.any(
      (p) => statuses[p]?.isPermanentlyDenied ?? false,
    );
    final message = video
        ? AppStrings.videoCallPermissionNeeded
        : AppStrings.voiceCallPermissionNeeded;
    // Once permanently denied, the OS won't prompt again, so point the
    // user to Settings.
    TopNotice.showError(
      context,
      blocked ? '$message ${AppStrings.enableInSettings}' : message,
    );
    if (blocked) await openAppSettings();
    return false;
  }
}
