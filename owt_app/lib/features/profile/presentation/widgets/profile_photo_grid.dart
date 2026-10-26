import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The user's photos, three per row.
class ProfilePhotoGrid extends StatelessWidget {
  const ProfilePhotoGrid({super.key, required this.photoUrls});

  final List<String> photoUrls;

  static const _gap = 3.0;
  static const _perRow = 3;

  @override
  Widget build(BuildContext context) {
    final rows = (photoUrls.length / _perRow).ceil();
    return Column(
      children: [
        for (var row = 0; row < rows; row++) ...[
          if (row != 0) const SizedBox(height: _gap),
          Row(
            children: [
              for (var col = 0; col < _perRow; col++) ...[
                if (col != 0) const SizedBox(width: _gap),
                Expanded(child: _tile(context, row * _perRow + col)),
              ],
            ],
          ),
        ],
      ],
    );
  }

  /// Empty slots at the end of the last row keep the tile widths even.
  Widget _tile(BuildContext context, int index) {
    if (index >= photoUrls.length) return const SizedBox.shrink();
    return AspectRatio(
      aspectRatio: 115 / 126,
      child: Image.network(
        photoUrls[index],
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(
          color: context.appColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
