import 'package:flutter/material.dart';

/// Theme-aware color tokens extracted from the OWT Figma design system
/// (the "Splash", "Numbet", "Verification", "Create Account" and
/// "Interests" light/dark frames).
///
/// Access via `context.appColors` rather than a static palette, since
/// several tokens differ between the light and dark frames.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOtpFilled,
    required this.inputBorder,
    required this.otpBorder,
    required this.logoTagline,
    required this.strongText,
  });

  final Color background;

  /// Headline text ("Enter Your Number", "Verify Your Number", ...).
  final Color textPrimary;

  /// Near-primary text: splash "New Here ?", input placeholders.
  final Color textSecondary;

  /// Lower-emphasis body copy (subtitles, helper text).
  final Color textMuted;

  /// Color of a filled OTP digit.
  final Color textOtpFilled;

  final Color inputBorder;
  final Color otpBorder;

  /// Color of the small "WHO'S OUT TONIGHT?" tag under the compact logo
  /// badge. Pure black/white, distinct from [textPrimary].
  final Color logoTagline;

  /// Headline + field-label color on the "Create Account" / "Interests"
  /// screens. A slightly different near-black/white shade than
  /// [textPrimary] in the Figma file.
  final Color strongText;

  /// Color of an empty OTP box's "-" placeholder. Identical in both themes.
  static const Color otpEmptyText = Color(0xFF81868C);

  /// Input placeholder / radio option label color on the "Create Account"
  /// screen. Identical in both themes.
  static const Color neutralGray = Color(0xFF777777);

  /// Unfilled segment color of a step progress bar. Identical in both
  /// themes; the filled segment differs (see [OnboardingProgressBar]).
  static const Color progressInactive = Color(0x1FFFFFFF);

  /// "Log out" label on the Settings screen. A fixed danger red, identical
  /// in both themes.
  static const Color dangerRed = Color(0xFFFF383C);

  /// Background of a success [TopNotice]. Identical in both themes.
  static const Color successGreen = Color(0xFF12B76A);

  /// Filled ("on") track color of the Settings screen's toggle switches.
  /// Identical in both themes.
  static const Color toggleOn = Color(0xFF7009F1);

  static const Color surface = Colors.white;
  static const Color onSurface = Colors.black;
  static const Color facebookBlue = Color(0xFF093EBE);

  static const Color brandOrange = Color(0xFFFD5929);
  static const Color brandPink = Color(0xFFFD2E81);
  static const Color brandPurple = Color(0xFF981796);

  static const AppColors dark = AppColors(
    background: Color(0xFF0A0B0D),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFFCFCFD),
    textMuted: Color(0xFF98A1B2),
    textOtpFilled: Color(0xFFD7DEE8),
    inputBorder: Color(0x1AFFFFFF),
    otpBorder: Color(0x1CFFFFFF),
    logoTagline: Colors.white,
    strongText: Colors.white,
  );

  static const AppColors light = AppColors(
    background: Color(0xFFFCFCFC),
    textPrimary: Color(0xFF1D2939),
    textSecondary: Color(0xFF344054),
    textMuted: Color(0xFF344054),
    textOtpFilled: Color(0xFF344054),
    inputBorder: Color(0x1A000000),
    otpBorder: Color(0x1C000000),
    logoTagline: Colors.black,
    strongText: Color(0xFF101828),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOtpFilled,
    Color? inputBorder,
    Color? otpBorder,
    Color? logoTagline,
    Color? strongText,
  }) {
    return AppColors(
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOtpFilled: textOtpFilled ?? this.textOtpFilled,
      inputBorder: inputBorder ?? this.inputBorder,
      otpBorder: otpBorder ?? this.otpBorder,
      logoTagline: logoTagline ?? this.logoTagline,
      strongText: strongText ?? this.strongText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textOtpFilled: Color.lerp(textOtpFilled, other.textOtpFilled, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      otpBorder: Color.lerp(otpBorder, other.otpBorder, t)!,
      logoTagline: Color.lerp(logoTagline, other.logoTagline, t)!,
      strongText: Color.lerp(strongText, other.strongText, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
