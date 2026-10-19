import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import 'going_tonight_icon.dart';

/// Bottom sheet opened from a profile's "Going Tonight" pill, explaining
/// what the badge means. Pops `true` when the user taps "Verify Mine".
class GoingTonightInfoSheet extends StatelessWidget {
  const GoingTonightInfoSheet({super.key});

  static const Color background = Color(0xFF0A0B0D);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GoingTonightIcon(),
            const SizedBox(height: 15),
            Text(
              AppStrings.goingTonightInfoTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.goingTonightTitle.copyWith(height: 1.2),
            ),
            const SizedBox(height: 15),
            const Text(
              AppStrings.goingTonightInfoBody,
              textAlign: TextAlign.center,
              style: AppTextStyles.goingTonightBody,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: AppStrings.goingTonightVerifyMine,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
