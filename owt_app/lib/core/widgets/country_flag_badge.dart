import 'package:flutter/material.dart';

import '../data/country.dart';

/// A circular flag image for [country], filled edge-to-edge like a real
/// flag badge (`Image.network` via flagcdn.com). Falls back to the
/// Unicode flag emoji if the image can't load (e.g. offline).
class CountryFlagBadge extends StatelessWidget {
  const CountryFlagBadge({super.key, required this.country, this.size = 28});

  final Country country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          country.flagImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Center(child: Text(country.flagEmoji, style: TextStyle(fontSize: size * 0.7))),
        ),
      ),
    );
  }
}
