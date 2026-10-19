import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gradient tokens extracted from the OWT Figma design system.
abstract final class AppGradients {
  /// The orange -> pink -> purple brand gradient used on CTA text and links
  /// ("Create Account").
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandOrange, AppColors.brandPink, AppColors.brandPurple],
    stops: [0, 0.51, 1],
  );

  /// The pink -> purple gradient used to fill the primary "Continue" button.
  /// Distinct from [brand]: only two stops, no orange.
  static const LinearGradient button = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandPink, AppColors.brandPurple],
  );

  /// Orange -> pink gradient filling the "Going Tonight" pill and the
  /// swipe-card's like button, on the match-making screen.
  static const LinearGradient goingTonight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFC6909), Color(0xFFD8135F)],
  );
}
