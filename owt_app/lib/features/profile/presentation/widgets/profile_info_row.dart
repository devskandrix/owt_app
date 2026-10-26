import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/my_profile.dart';
import 'profile_tag_chip.dart';

/// Avatar photo beside the name / verified-badge row, the stats row
/// (Friends), every interest as a chip, and the tagline. Missing pieces
/// are simply left out.
class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.profile,
    this.showFriends = true,
    this.showInterests = true,
  });

  final MyProfile profile;

  /// The tappable Friends count: only on the user's own profile.
  final bool showFriends;

  /// The interest chips; off on the user's own profile, which shows them
  /// in their own editable section instead.
  final bool showInterests;

  static const double _avatarSize = 108;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    final fallback = Assets.images.profileAvatar.image(
      width: _avatarSize,
      height: _avatarSize,
      fit: BoxFit.cover,
    );
    final avatarUrl = profile.avatarUrl;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: avatarUrl == null
              ? fallback
              : Image.network(
                  avatarUrl,
                  width: _avatarSize,
                  height: _avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fallback,
                ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.profileName.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 3),
                    SvgPicture.asset(
                      Assets.icons.verifiedBadge,
                      width: 14,
                      height: 14,
                    ),
                  ],
                ],
              ),
              if (showFriends) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.pushNamed(AppRoute.friends.name),
                  child: _Stat(
                    value: _compactCount(profile.matchCount),
                    label: AppStrings.profileFriends,
                  ),
                ),
              ],
              if (showInterests && profile.interests.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final interest in profile.interests)
                      ProfileTagChip(label: interest.name, icon: interest.icon),
                  ],
                ),
              ],
              if (profile.tagline case final tagline?) ...[
                const SizedBox(height: 8),
                Text(
                  tagline,
                  style: AppTextStyles.profileTagline.copyWith(
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// 1500 -> "1.5k", 2000000 -> "2M", like the Figma "1.5k Views".
String _compactCount(int n) {
  String fmt(double v, String suffix) {
    final text = v.toStringAsFixed(v < 10 ? 1 : 0);
    return '${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}$suffix';
  }

  if (n >= 1000000) return fmt(n / 1000000, 'M');
  if (n >= 1000) return fmt(n / 1000, 'k');
  return '$n';
}

/// A number over its label, e.g. "23" / "Friends".
class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.profileStatValue.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.profileStatLabel),
      ],
    );
  }
}
