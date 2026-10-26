import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../../gen/assets.gen.dart';

/// A section title with a gradient "View All" link (hidden when the
/// section has nothing to show), optionally preceded by the gradient
/// trending-up icon (used by the "Trending" section).
class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.showTrendingIcon = false,
    this.showViewAll = true,
  });

  final String title;
  final bool showTrendingIcon;
  final bool showViewAll;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Row(
      children: [
        if (showTrendingIcon) ...[
          SvgPicture.asset(Assets.icons.trendingUp, width: 24, height: 24),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(color: textColor),
          ),
        ),
        if (showViewAll)
          GradientText(
            AppStrings.viewAllLabel,
            gradient: AppGradients.button,
            style: AppTextStyles.viewAll,
          ),
      ],
    );
  }
}
