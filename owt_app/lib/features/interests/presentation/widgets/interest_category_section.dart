import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/interest.dart';
import 'interest_chip.dart';

/// A labeled group of interest chips laid out 3-per-row, matching the
/// "Music" / "Night Life" / "Vibes" sections on the Interests screen.
class InterestCategorySection extends StatelessWidget {
  const InterestCategorySection({
    super.key,
    required this.title,
    required this.interests,
    required this.selectedIds,
    required this.onToggle,
  });

  final String title;
  final List<Interest> interests;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  static const _columns = 3;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final rows = <List<Interest>>[
      for (var i = 0; i < interests.length; i += _columns)
        interests.skip(i).take(_columns).toList(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.fieldLabel.copyWith(color: colors.strongText),
        ),
        const SizedBox(height: 12),
        for (final row in rows) ...[
          if (row != rows.first) const SizedBox(height: 7),
          Row(
            children: [
              for (final interest in row) ...[
                if (interest != row.first) const SizedBox(width: 5),
                Expanded(
                  child: InterestChip(
                    label: interest.name,
                    selected: selectedIds.contains(interest.id),
                    onTap: () => onToggle(interest.id),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
