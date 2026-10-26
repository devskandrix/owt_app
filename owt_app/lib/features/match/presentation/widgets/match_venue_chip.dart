import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// The translucent "lord of drinks..." pill with a green online dot and a
/// fire/going-count, sitting above the swipe card.
class MatchVenueChip extends StatelessWidget {
  const MatchVenueChip({
    super.key,
    this.name = AppStrings.matchVenueChipName,
    this.imageUrl,
    this.goingTonightNow = 0,
    this.viewCount = 0,
  });

  final String name;

  /// Shown in the circle avatar; falls back to a placeholder when null.
  final String? imageUrl;

  /// Shown next to the green dot.
  final int goingTonightNow;

  /// Shown next to the fire icon.
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(child: _avatar()),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.matchVenueChipName,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 14,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34C759),
            ),
          ),
          const SizedBox(width: 6),
          Text('$goingTonightNow', style: AppTextStyles.matchVenueChipCount),
          const SizedBox(width: 12),
          SvgPicture.asset(Assets.icons.fire, width: 16, height: 16),
          const SizedBox(width: 4),
          Text('$viewCount', style: AppTextStyles.matchVenueChipCount),
        ],
      ),
    );
  }

  Widget _avatar() {
    final placeholder = Assets.images.venueTeal.image(
      width: 24,
      height: 24,
      fit: BoxFit.cover,
    );
    final url = imageUrl;
    if (url == null || url.isEmpty) return placeholder;
    return Image.network(
      url,
      width: 24,
      height: 24,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
