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
///
/// Photos are [ImageProvider]s so a profile can come from bundled sample
/// assets (`AssetGenImage.provider()`) or the API ([NetworkImage]).
class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.photos,
    required this.onGoingTonightTap,
    this.name = AppStrings.matchProfileName,
    this.avatar,
    this.showGoingTonight = true,
    this.interests,
    this.aboutMe,
  });

  /// Whether this person has a Going Tonight badge (shows the pill).
  final bool showGoingTonight;

  final String name;

  /// Header avatar; defaults to the first photo, then the sample avatar.
  final ImageProvider? avatar;

  /// Main photo first, then the further photos shown below the details.
  /// May be empty — a dark placeholder takes the main photo's place.
  final List<ImageProvider> photos;

  /// "Interested In" labels. Null shows the sample tags (screens not yet
  /// backed by the API); empty hides the section.
  final List<String>? interests;

  /// "About Me" text. Null shows the sample quote when [interests] is
  /// null too (sample profiles), and hides the section otherwise.
  final String? aboutMe;

  /// Tapping the "Going Tonight" pill starts the badge verification flow.
  final VoidCallback onGoingTonightTap;

  bool get _isSample => interests == null;

  @override
  Widget build(BuildContext context) {
    final avatarImage =
        avatar ??
        (photos.isNotEmpty
            ? photos.first
            : Assets.images.profileAvatar.provider());
    final about = aboutMe ?? (_isSample ? AppStrings.matchAboutMeQuote : null);
    final interestList = interests;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ClipOval(
                child: Image(
                  image: avatarImage,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const _PhotoPlaceholder(width: 42, height: 42),
                ),
              ),
              const SizedBox(width: 8),
              // Name + verified badge take all the space up to the pill;
              // the name wraps instead of truncating.
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.matchCardName,
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      Assets.icons.verifiedBadge,
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
              ),
              if (showGoingTonight) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onGoingTonightTap,
                  child: Container(
                    height: 36,
                    // Figma: 6px pill padding + 3px inner inset, 2px gap.
                    padding: const EdgeInsets.symmetric(horizontal: 9),
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
                        const SizedBox(width: 2),
                        Text(
                          AppStrings.matchGoingTonight,
                          style: AppTextStyles.matchGoingTonight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 7),
        _Photo(image: photos.isNotEmpty ? photos.first : null),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (interestList == null || interestList.isNotEmpty) ...[
                Text(
                  AppStrings.interestedInLabel,
                  style: AppTextStyles.matchSectionLabel,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interestList == null
                      ? _sampleTags()
                      : [
                          for (final interest in interestList)
                            MatchTagChip(
                              icon: SvgPicture.asset(Assets.icons.musicNote),
                              label: interest,
                            ),
                        ],
                ),
                const SizedBox(height: 12),
              ],
              if (about != null) ...[
                Text(
                  AppStrings.aboutMeLabel,
                  style: AppTextStyles.matchSectionLabel,
                ),
                const SizedBox(height: 6),
                Text(about, style: AppTextStyles.matchAboutMeText),
              ],
            ],
          ),
        ),
        for (var i = 1; i < photos.length; i++) ...[
          SizedBox(height: i == 1 ? 36 : 12),
          _Photo(image: photos[i]),
        ],
      ],
    );
  }

  static List<Widget> _sampleTags() => [
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
  ];
}

/// A full-width 390:497 profile photo, or a placeholder when [image] is
/// null, still loading, or fails.
class _Photo extends StatelessWidget {
  const _Photo({required this.image});

  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    final provider = image;
    return AspectRatio(
      aspectRatio: 390 / 497,
      child: provider == null
          ? const _PhotoPlaceholder()
          : Image(
              image: provider,
              fit: BoxFit.cover,
              width: double.infinity,
              frameBuilder: (context, child, frame, wasSyncLoaded) =>
                  wasSyncLoaded || frame != null
                  ? child
                  : const _PhotoPlaceholder(),
              errorBuilder: (_, _, _) => const _PhotoPlaceholder(),
            ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.white.withValues(alpha: 0.05),
    );
  }
}
