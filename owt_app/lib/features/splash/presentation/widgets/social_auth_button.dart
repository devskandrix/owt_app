import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A pill-shaped button with a leading icon, used for third-party sign-in.
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.labelStyle,
    required this.backgroundColor,
    required this.onPressed,
    this.isLoading = false,
  });

  final String iconAsset;
  final String label;
  final TextStyle labelStyle;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 60),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: labelStyle.color,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(iconAsset, width: 24, height: 24),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      label,
                      style: labelStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
