import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'social_auth_button.dart';

/// The "Continue with Google" / "Continue with Facebook" button stack.
class SplashSocialButtons extends StatelessWidget {
  const SplashSocialButtons({
    super.key,
    required this.onContinueWithGoogle,
    required this.onContinueWithFacebook,
    this.isGoogleSignInLoading = false,
  });

  final VoidCallback onContinueWithGoogle;
  final VoidCallback onContinueWithFacebook;
  final bool isGoogleSignInLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialAuthButton(
          iconAsset: Assets.icons.googleIcon,
          label: AppStrings.continueWithGoogle,
          labelStyle: AppTextStyles.socialButtonBold,
          backgroundColor: AppColors.surface,
          onPressed: onContinueWithGoogle,
          isLoading: isGoogleSignInLoading,
        ),
        const SizedBox(height: 14),
        SocialAuthButton(
          iconAsset: Assets.icons.facebookIcon,
          label: AppStrings.continueWithFacebook,
          labelStyle: AppTextStyles.socialButtonSemiBold,
          backgroundColor: AppColors.facebookBlue,
          onPressed: onContinueWithFacebook,
        ),
      ],
    );
  }
}
