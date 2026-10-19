/// A country entry for the phone number country-code picker.
class Country {
  const Country({
    required this.name,
    required this.isoCode,
    required this.dialCode,
  });

  final String name;

  /// ISO 3166-1 alpha-2 code, e.g. "IN". Used to derive [flagEmoji].
  final String isoCode;

  /// E.164 calling code including the leading "+", e.g. "+91".
  final String dialCode;

  /// Renders [isoCode] as a Unicode regional-indicator flag emoji. Used as
  /// an offline fallback when [flagImageUrl] fails to load.
  String get flagEmoji {
    const regionalIndicatorBase = 0x1F1E6;
    const asciiUppercaseA = 0x41;
    return String.fromCharCodes(
      isoCode.toUpperCase().codeUnits.map(
        (unit) => regionalIndicatorBase + (unit - asciiUppercaseA),
      ),
    );
  }

  /// A real flag image (flagcdn.com, free and keyless) that fills a circle
  /// cleanly, unlike the emoji glyph.
  String get flagImageUrl => 'https://flagcdn.com/w80/${isoCode.toLowerCase()}.png';
}
