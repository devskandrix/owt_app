import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'live_count_badge.dart';
import 'venue.dart';
import 'venue_image.dart';

/// A compact venue card used in the Top Clubs / Near You / Recently
/// Viewed horizontal lists. No border here — only the Trending carousel
/// card gets one (see [TrendingCard]). The photo and its badge overlay
/// stay white in both themes; the copy below the photo sits on the page
/// background, so it adapts to theme.
class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.venue, required this.width});

  final Venue venue;
  final double width;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 137 / 127,
                child: VenueImage(venue: venue),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: LiveCountBadge(count: venue.liveCount),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(Assets.icons.fire, width: 16, height: 16),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  '${venue.goingCount} ${AppStrings.goingTonightSuffix}',
                  style: AppTextStyles.venueGoingText.copyWith(
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            venue.name,
            style: AppTextStyles.venueCardTitle.copyWith(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            venue.location,
            style: AppTextStyles.venueLocation,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
