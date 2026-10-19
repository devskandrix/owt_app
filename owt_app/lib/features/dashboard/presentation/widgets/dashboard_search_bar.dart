import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// A single bordered search field with the filter icon inset at its
/// trailing edge (per Figma, the filter icon sits inside the same bordered
/// box as the search text, not in a separate box beside it). Page-level
/// chrome (border, icons, hint) adapts to theme; content drawn over venue
/// photos elsewhere on this screen stays white regardless of theme.
class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: colors.inputBorder)),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.icons.search,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              AppStrings.searchClubHint,
              style: AppTextStyles.searchHint.copyWith(
                color: AppColors.neutralGray,
              ),
            ),
          ),
          SvgPicture.asset(
            Assets.icons.filter,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
