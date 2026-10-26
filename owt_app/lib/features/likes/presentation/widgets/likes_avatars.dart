import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../../../matchmaking/domain/entities/received_like.dart';

/// A like's profile photo, or the default avatar when it has none.
ImageProvider likeAvatar(ReceivedLike like) {
  final url = like.avatarUrl;
  return url != null
      ? NetworkImage(url)
      : Assets.images.profileAvatar.provider();
}

/// Avatars for the summary card's overlapping previews: the first
/// [count] distinct people in [likes].
List<ImageProvider> likePreviews(List<ReceivedLike> likes, {int count = 3}) {
  final seen = <String>{};
  return [
    for (final like in likes)
      if (seen.add(like.userId)) likeAvatar(like),
  ].take(count).toList();
}

/// Round photo that falls back to the default avatar if it fails to load.
class LikeCircleImage extends StatelessWidget {
  const LikeCircleImage({super.key, required this.image, required this.size});

  final ImageProvider image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image(
        image: image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Assets.images.profileAvatar.image(
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
