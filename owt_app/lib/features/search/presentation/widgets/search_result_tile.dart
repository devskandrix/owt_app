import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../dashboard/presentation/widgets/venue.dart';
import '../../../dashboard/presentation/widgets/venue_image.dart';

/// A single search result row: cover thumbnail, title with the part that
/// matches [query] painted in [AppGradients.brand], a location line, and
/// an optional [trailing] widget (the remove button on a recent search).
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.venue,
    required this.query,
    this.trailing,
  });

  final Venue venue;
  final Widget? trailing;

  /// The search text; its first case-insensitive occurrence in the name is
  /// highlighted.
  final String query;

  @override
  Widget build(BuildContext context) {
    final name = venue.name;
    final start = query.isEmpty
        ? -1
        : name.toLowerCase().indexOf(query.toLowerCase());
    final titleStyle = AppTextStyles.searchResultTitle.copyWith(
      color: context.appColors.textPrimary,
    );
    return SizedBox(
      height: 71,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 75, height: 71, child: VenueImage(venue: venue)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  start < 0
                      ? TextSpan(text: name, style: titleStyle)
                      : TextSpan(
                          children: [
                            TextSpan(
                              text: name.substring(0, start),
                              style: titleStyle,
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GradientText(
                                name.substring(start, start + query.length),
                                gradient: AppGradients.brand,
                                style: titleStyle,
                              ),
                            ),
                            TextSpan(
                              text: name.substring(start + query.length),
                              style: titleStyle,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 7),
                Text(
                  venue.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.searchResultLocation,
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
