import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "Be Yourself" / "Show your vibes" / "We keep it safe" row on the
/// "Add your photos" screen.
class FeatureBlurbRow extends StatelessWidget {
  const FeatureBlurbRow({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget blurb(String title, String desc) {
      return Expanded(
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.featureBlurbTitle.copyWith(
                color: colors.strongText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: AppTextStyles.featureBlurbDesc.copyWith(
                color: colors.strongText,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        blurb(AppStrings.beYourselfTitle, AppStrings.beYourselfDesc),
        blurb(AppStrings.showVibesTitle, AppStrings.showVibesDesc),
        blurb(AppStrings.keepSafeTitle, AppStrings.keepSafeDesc),
      ],
    );
  }
}
