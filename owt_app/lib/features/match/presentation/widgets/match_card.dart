import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'match_tag_chip.dart';

/// The scrollable profile card: avatar/name/"Going Tonight" header, the
/// main photo, the "Interested In" tags, the "About Me" quote, and further
/// photos of the same profile below — all one continuous scrollable
/// profile, per Figma (not separate swipe cards).
class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.mainPhoto,
    required this.morePhotos,
    required this.onGoingTonightTap,
  });

  final AssetGenImage mainPhoto;
  final List<AssetGenImage> morePhotos;

  /// Tapping the "Going Tonight" pill starts the badge verification flow.
  final VoidCallback onGoingTonightTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ClipOval(
                child: Assets.images.profileAvatar.image(
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.matchProfileName,
                style: AppTextStyles.matchCardName,
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                Assets.icons.verifiedBadge,
                width: 14,
                height: 14,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onGoingTonightTap,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.goingTonight,
                    borderRadius: BorderRadius.all(Radius.circular(500)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.fireWhite,
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.matchGoingTonight,
                        style: AppTextStyles.matchGoingTonight,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        AspectRatio(
          aspectRatio: 390 / 497,
          child: mainPhoto.image(fit: BoxFit.cover, width: double.infinity),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.interestedInLabel,
                style: AppTextStyles.matchSectionLabel,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  MatchTagChip(
                    icon: SvgPicture.asset(Assets.icons.musicNote),
                    label: AppStrings.tagHouseMusic,
                  ),
                  MatchTagChip(
                    icon: SvgPicture.asset(Assets.icons.headphone),
                    label: AppStrings.tagTechno,
                  ),
                  MatchTagChip(
                    icon: SvgPicture.asset(Assets.icons.wineGlass),
                    label: AppStrings.tagVipTables,
                  ),
                  MatchTagChip(
                    icon: SvgPicture.asset(Assets.icons.palmTree),
                    label: AppStrings.tagBeachClub,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.aboutMeLabel,
                style: AppTextStyles.matchSectionLabel,
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.matchAboutMeQuote,
                style: AppTextStyles.matchAboutMeText,
              ),
            ],
          ),
        ),
        for (var i = 0; i < morePhotos.length; i++) ...[
          SizedBox(height: i == 0 ? 36 : 12),
          AspectRatio(
            aspectRatio: 390 / 497,
            child: morePhotos[i].image(
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ],
    );
  }
}
