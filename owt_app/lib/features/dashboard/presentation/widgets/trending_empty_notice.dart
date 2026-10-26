import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// Shown under the "Trending" title when no club is trending — a muted,
/// bordered note in place of the carousel.
class TrendingEmptyNotice extends StatelessWidget {
  const TrendingEmptyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: colors.textPrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.fire, width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppStrings.trendingEmptyMessage,
              style: AppTextStyles.authSubtitle.copyWith(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
