import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// Back chevron + centered "Setting" title + trailing gear icon.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset(
              Assets.icons.backChevron,
              width: 9,
              height: 18,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppStrings.settingsTitle,
                style: AppTextStyles.settingsTitle.copyWith(color: textColor),
              ),
            ),
          ),
          SvgPicture.asset(
            Assets.icons.settingsGear,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
