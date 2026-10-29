import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A centered message in place of a chat list or conversation (empty or
/// failed to load).
class ChatUnavailable extends StatelessWidget {
  const ChatUnavailable({super.key, this.message = AppStrings.chatUnavailable});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.profileBio.copyWith(
            color: context.appColors.textMuted,
          ),
        ),
      ),
    );
  }
}
