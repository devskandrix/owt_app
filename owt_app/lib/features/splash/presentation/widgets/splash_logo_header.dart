import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// The OWT wordmark and "WHO'S OUT TONIGHT?" tagline shown on the splash screen.
class SplashLogoHeader extends StatelessWidget {
  const SplashLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.owtLogoPng.image(
          width: 220,
          height: 156,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 11),
        Text(AppStrings.tagline, style: AppTextStyles.tagline),
      ],
    );
  }
}
