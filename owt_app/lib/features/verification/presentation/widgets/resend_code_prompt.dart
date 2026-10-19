import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "Did't receive code ? Resend Code" row shown below the OTP boxes.
class ResendCodePrompt extends StatelessWidget {
  const ResendCodePrompt({super.key, required this.onResend});

  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Text.rich(
      TextSpan(
        style: AppTextStyles.resendPrompt.copyWith(color: colors.textPrimary),
        children: [
          const TextSpan(text: AppStrings.didntReceiveCode),
          TextSpan(
            text: AppStrings.resendCode,
            style: const TextStyle(color: AppColors.brandPink),
            recognizer: TapGestureRecognizer()..onTap = onResend,
          ),
        ],
      ),
    );
  }
}
