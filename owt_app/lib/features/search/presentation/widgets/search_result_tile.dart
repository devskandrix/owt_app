import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../dashboard/presentation/widgets/venue.dart';

/// A single search result row: poster thumbnail, title with the matched
/// substring painted in [AppGradients.brand], and a location line.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({super.key, required this.venue, required this.matchLength});

  final Venue venue;

  /// How many leading characters of [Venue.name] matched the query and
  /// should be gradient-highlighted (per Figma, only the matched prefix).
  final int matchLength;

  @override
  Widget build(BuildContext context) {
    final match = venue.name.substring(0, matchLength);
    final rest = venue.name.substring(matchLength);
    final titleStyle = AppTextStyles.searchResultTitle.copyWith(color: context.appColors.textPrimary);
    return SizedBox(
      height: 71,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 75, height: 71, child: venue.image.image(fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GradientText(match, gradient: AppGradients.brand, style: titleStyle),
                      ),
                      TextSpan(text: rest, style: titleStyle),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Text(venue.location, style: AppTextStyles.searchResultLocation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
