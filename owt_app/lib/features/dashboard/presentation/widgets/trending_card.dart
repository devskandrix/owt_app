import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'live_count_badge.dart';
import 'venue.dart';
import 'venue_image.dart';

/// A large trending-carousel card: photo with a floating live-count badge,
/// then icon+going-count, title and location stacked below. The border
/// flips to a dark base color in light theme so it stays visible against
/// the light scaffold background instead of washing out. The photo and
/// its badge overlay stay white in both themes; the copy below the photo
/// sits on the page background, so it adapts to theme.
class TrendingCard extends StatelessWidget {
  const TrendingCard({super.key, required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorder = isDark ? Colors.white : Colors.black;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cardBorder.withValues(alpha: 0.15)),
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fills whatever height is left over after the text block below,
          // rather than an AspectRatio deriving its height from the card's
          // width: TrendingCarousel's SizedBox fixes this card's total
          // height, but the card's width varies with screen width (84% of
          // viewport), so a width-driven aspect ratio would blow past that
          // fixed height on any wider device (verified: 546px overflow at a
          // ~812px-wide viewport).
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                VenueImage(venue: venue),
                Positioned(
                  right: 13,
                  top: 13,
                  child: LiveCountBadge(count: venue.liveCount),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 11, 11, 0),
            // Pinned to the design's own type scale: this card's height is a
            // fixed pixel budget (see TrendingCarousel's SizedBox), so its
            // text must render at a fixed size instead of following the
            // device's accessibility text-size setting, which was the cause
            // of a few-pixel bottom overflow on devices with a larger system
            // font scale than the one this was designed against.
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.fire,
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${venue.goingCount} ${AppStrings.goingTonightSuffix}',
                          style: AppTextStyles.venueGoingText.copyWith(
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    venue.name,
                    style: AppTextStyles.trendingCardTitle.copyWith(
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    venue.location,
                    style: AppTextStyles.venueLocation,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
