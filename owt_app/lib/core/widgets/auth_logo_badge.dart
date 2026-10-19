import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../strings/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Compact OWT wordmark + tagline used at the top of secondary auth screens
/// (phone number entry, OTP verification), as opposed to the large hero
/// version on the Splash screen.
class AuthLogoBadge extends StatelessWidget {
  const AuthLogoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.owtLogoPng.image(width: 118, height: 64, fit: BoxFit.contain),
        const SizedBox(height: 5),
        Text(
          AppStrings.tagline,
          style: AppTextStyles.logoBadgeTagline.copyWith(color: context.appColors.logoTagline),
        ),
      ],
    );
  }
}
