import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// "I confirm that I am agree to the terms of use and privacy policy"
/// checkbox row on the Create Account screen. Note the link text is
/// lowercase ("terms of use", "privacy policy") on this screen, unlike the
/// Title Case shared copy used on Splash.
class TermsCheckboxRow extends StatelessWidget {
  const TermsCheckboxRow({
    super.key,
    required this.checked,
    required this.onChanged,
    required this.onTermsOfUse,
    required this.onPrivacyPolicy,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTermsOfUse;
  final VoidCallback onPrivacyPolicy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final linkStyle = AppTextStyles.inputPlaceholder.copyWith(
      foreground: Paint()
        ..shader = AppGradients.brand.createShader(
          const Rect.fromLTWH(0, 0, 100, 20),
        ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(!checked),
          child: checked
              ? SvgPicture.asset(
                  Assets.icons.checkboxFill,
                  width: 24,
                  height: 24,
                )
              : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.neutralGray,
                      width: 1.5,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: AppTextStyles.inputPlaceholder.copyWith(
                color: colors.strongText,
              ),
              children: [
                const TextSpan(text: AppStrings.termsConfirmPrefix),
                TextSpan(
                  text: AppStrings.createAccountTermsOfUse,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = onTermsOfUse,
                ),
                const TextSpan(text: AppStrings.legalNoticeAnd),
                TextSpan(
                  text: AppStrings.createAccountPrivacyPolicy,
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
