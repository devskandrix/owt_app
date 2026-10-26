import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'likes_avatars.dart';

/// A person row: avatar, name, location, and the club they're linked to,
/// with optional [trailing] widgets (e.g. Confirm / X on Likes). Shared by
/// the Likes and Friends lists.
class PersonRow extends StatelessWidget {
  const PersonRow({
    super.key,
    required this.avatar,
    required this.name,
    this.location,
    this.clubName,
    this.clubImageUrl,
    this.trailing = const [],
  });

  final ImageProvider avatar;
  final String name;
  final String? location;
  final String? clubName;
  final String? clubImageUrl;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final location = this.location;
    final clubName = this.clubName;
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          LikeCircleImage(image: avatar, size: 58),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.likesName.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (location != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.likesCaption,
                  ),
                ],
                if (clubName != null && clubName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _ClubIcon(url: clubImageUrl),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          clubName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.likesClub.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (trailing.isNotEmpty) ...[const SizedBox(width: 12), ...trailing],
        ],
      ),
    );
  }
}

class _ClubIcon extends StatelessWidget {
  const _ClubIcon({this.url});

  final String? url;

  static const double _size = 18;

  @override
  Widget build(BuildContext context) {
    final fallback = Assets.images.likesClubIcon.image(
      width: _size,
      height: _size,
      fit: BoxFit.cover,
    );
    final url = this.url;
    return ClipOval(
      child: url == null
          ? fallback
          : Image.network(
              url,
              width: _size,
              height: _size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}
