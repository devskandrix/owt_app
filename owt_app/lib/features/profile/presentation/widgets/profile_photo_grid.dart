import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

/// 3x2 grid of the user's photos. All six tiles reuse the same source
/// photo, matching the Figma placeholder (which repeats one stock photo
/// across every cell).
class ProfilePhotoGrid extends StatelessWidget {
  const ProfilePhotoGrid({super.key});

  static const _gap = 3.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(),
        const SizedBox(height: _gap),
        _row(),
      ],
    );
  }

  Widget _row() {
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i != 0) const SizedBox(width: _gap),
          Expanded(
            child: AspectRatio(
              aspectRatio: 115 / 126,
              child: Assets.images.profilePhoto.image(fit: BoxFit.cover),
            ),
          ),
        ],
      ],
    );
  }
}
