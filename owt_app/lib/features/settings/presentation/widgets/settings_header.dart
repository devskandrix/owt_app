import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// Back chevron + centered title + trailing gear icon. Defaults to the
/// "Setting" title; sub-screens (e.g. About App) pass their own [title] and
/// hide the gear.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.onBack,
    this.title = AppStrings.settingsTitle,
    this.showGear = true,
  });

  final VoidCallback onBack;
  final String title;
  final bool showGear;

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
                title,
                style: AppTextStyles.settingsTitle.copyWith(color: textColor),
              ),
            ),
          ),
          if (showGear)
            SvgPicture.asset(
              Assets.icons.settingsGear,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            )
          else
            // Keeps the title centered against the back chevron.
            const SizedBox(width: 24),
        ],
      ),
    );
  }
}
