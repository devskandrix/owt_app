import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// One line of the "Verifying your location" checklist: a green check when
/// [done], a green dash while still pending.
class GoingTonightStatusRow extends StatelessWidget {
  const GoingTonightStatusRow({
    super.key,
    required this.label,
    required this.done,
  });

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            done ? Assets.icons.statusCheckDone : Assets.icons.statusCheckPending,
            key: ValueKey(done),
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(label, style: AppTextStyles.goingTonightBody)),
      ],
    );
  }
}
