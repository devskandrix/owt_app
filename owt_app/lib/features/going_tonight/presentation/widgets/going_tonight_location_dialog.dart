import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'going_tonight_dialog_frame.dart';
import 'going_tonight_icon.dart';

/// In-app explainer shown before the OS location prompt, which can't be
/// restyled. Pops `true` if the user agrees — the OS prompt follows, and
/// that's where the actual while-using / once choice is made — or `false`.
/// Its buttons deliberately don't repeat the OS prompt's wording, so the
/// two don't read as the same dialog twice.
///
/// Defaults to the Going Tonight copy; Home passes its own [message] and
/// [confirmLabel] for nearby clubs.
class GoingTonightLocationDialog extends StatelessWidget {
  const GoingTonightLocationDialog({
    super.key,
    this.message = AppStrings.goingTonightLocationBody,
    this.confirmLabel = AppStrings.goingTonightVerifyMyLocation,
  });

  final String message;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    void close(bool allowed) => Navigator.of(context).pop(allowed);
    return GoingTonightDialogFrame(
      onClose: () => close(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GoingTonightIcon(),
          const SizedBox(height: 15),
          const Text(
            AppStrings.goingTonightLocationTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.goingTonightTitle,
          ),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.goingTonightBody,
          ),
          const SizedBox(height: 15),
          _PillButton(
            label: confirmLabel,
            decoration: const BoxDecoration(gradient: AppGradients.button),
            onTap: () => close(true),
          ),
          const SizedBox(height: 15),
          _PillButton(
            label: AppStrings.goingTonightNotNow,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
            onTap: () => close(false),
          ),
        ],
      ),
    );
  }
}

/// 42px full-width pill; [decoration] supplies the fill/border variant and
/// is given the pill radius here.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.decoration,
    required this.onTap,
  });

  final String label;
  final BoxDecoration decoration;
  final VoidCallback onTap;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(38));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: DecoratedBox(
        decoration: decoration.copyWith(borderRadius: _radius),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: _radius,
            onTap: onTap,
            child: Center(
              child: Text(label, style: AppTextStyles.goingTonightPillButton),
            ),
          ),
        ),
      ),
    );
  }
}
