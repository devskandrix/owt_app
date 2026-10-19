import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "By continuing. You agree to our Terms of Use and Privacy Policy" text,
/// with the two policy names picked out in the brand gradient.
class SplashLegalNotice extends StatelessWidget {
  const SplashLegalNotice({
    super.key,
    required this.onTermsOfUse,
    required this.onPrivacyPolicy,
  });

  final VoidCallback onTermsOfUse;
  final VoidCallback onPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final linkStyle = AppTextStyles.legal.copyWith(
      foreground: Paint()
        ..shader = AppGradients.brand.createShader(
          const Rect.fromLTWH(0, 0, 100, 20),
        ),
    );

    return Text.rich(
      TextSpan(
        style: AppTextStyles.legal,
        children: [
          const TextSpan(text: AppStrings.legalNoticePrefix),
          TextSpan(
            text: AppStrings.termsOfUse,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = onTermsOfUse,
          ),
          const TextSpan(text: AppStrings.legalNoticeAnd),
          TextSpan(
            text: AppStrings.privacyPolicy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicy,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
