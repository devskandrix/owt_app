import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// The translucent "lord of drinks..." pill with a green online dot and a
/// fire/going-count, sitting above the swipe card.
class MatchVenueChip extends StatelessWidget {
  const MatchVenueChip({super.key});

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
          ClipOval(
            child: Assets.images.venueTeal.image(
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppStrings.matchVenueChipName,
            style: AppTextStyles.matchVenueChipName,
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
          Text(
            AppStrings.matchOnlineCount,
            style: AppTextStyles.matchVenueChipCount,
          ),
          const SizedBox(width: 12),
          SvgPicture.asset(Assets.icons.fire, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(
            AppStrings.matchFireCount,
            style: AppTextStyles.matchVenueChipCount,
          ),
        ],
      ),
    );
  }
}
