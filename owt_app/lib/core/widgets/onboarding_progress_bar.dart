import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

/// Multi-segment step indicator shown under the headline on the
/// "Create Account" / "Interests" onboarding screens.
///
/// The filled segment is solid white in dark mode but the brand gradient in
/// light mode (an asymmetry confirmed directly against the Figma file); the
/// unfilled segment is the same translucent white in both themes.
class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({super.key, required this.currentStep, required this.totalSteps});

  /// 1-indexed: segments before and including this one are filled.
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
          if (i != 0) const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: i < currentStep ? (isDark ? Colors.white : null) : AppColors.progressInactive,
                gradient: i < currentStep && !isDark ? AppGradients.button : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
