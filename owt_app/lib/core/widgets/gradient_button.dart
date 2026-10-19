import 'package:flutter/material.dart';

import '../theme/app_gradients.dart';
import '../theme/app_text_styles.dart';

/// Full-width pill button filled with the pink -> purple button gradient,
/// used for primary call-to-actions ("Continue") across the auth flow.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  /// When false, the button is grayed out and not tappable — e.g. before
  /// a required minimum selection is met.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: SizedBox(
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.button,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(38),
              onTap: enabled && !isLoading ? onPressed : null,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(label, style: AppTextStyles.primaryButton),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
