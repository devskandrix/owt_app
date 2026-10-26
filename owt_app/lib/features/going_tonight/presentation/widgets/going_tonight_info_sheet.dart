import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../gen/assets.gen.dart';
import 'going_tonight_icon.dart';

/// Bottom sheet opened from a profile's "Going Tonight" pill, explaining
/// what the badge means — also opened automatically at the end of a
/// Going Tonight profile. Pops `true` when the user taps "Verify Mine";
/// the close (X) or a swipe down dismisses it.
class GoingTonightInfoSheet extends StatelessWidget {
  const GoingTonightInfoSheet({super.key});

  static const Color background = Color(0xFF0A0B0D);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
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
          // Same 18px X as the Going Tonight dialogs, padded for a usable
          // tap target.
          Positioned(
            top: 6,
            right: 3,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  Assets.icons.closeWhite,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
