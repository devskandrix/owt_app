import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// The "Ibiza Lover" interest pill: a palm-tree icon plus a themed label
/// inside a bordered pill. Border flips to a dark base color in light
/// theme so it stays visible against the light scaffold background.
class ProfileTagChip extends StatelessWidget {
  const ProfileTagChip({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.icons.palmTree, width: 16, height: 16),
          const SizedBox(width: 2),
          Text(AppStrings.profileTag, style: AppTextStyles.profileTagLabel.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
