import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

/// Green "live" dot + viewer count, overlaid on a venue photo.
class LiveCountBadge extends StatelessWidget {
  const LiveCountBadge({super.key, required this.count});

  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.33),
        border: Border.all(color: Colors.white.withValues(alpha: 0.11)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF34C759),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(count, style: AppTextStyles.liveBadgeCount),
        ],
      ),
    );
  }
}
