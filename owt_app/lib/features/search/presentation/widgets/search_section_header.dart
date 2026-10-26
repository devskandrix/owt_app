import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';

/// A section title on the Search screen ("Recent", "All Clubs") with an
/// optional gradient action on the right ("Clear All"), styled like the
/// dashboard's "Trending … View All" header.
class SearchSectionHeader extends StatelessWidget {
  const SearchSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GradientText(
                actionLabel!,
                gradient: AppGradients.button,
                style: AppTextStyles.viewAll,
              ),
            ),
          ),
      ],
    );
  }
}
