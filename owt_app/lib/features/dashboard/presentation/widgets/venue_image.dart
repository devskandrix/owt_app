import 'package:flutter/material.dart';

import 'venue.dart';

/// Renders a [Venue]'s photo: its `networkImageUrl` when set (real API
/// data), falling back to the local placeholder asset in [Venue.image]
/// while that loads, on failure, or when there's no cover image at all.
class VenueImage extends StatelessWidget {
  const VenueImage({super.key, required this.venue, this.fit = BoxFit.cover});

  final Venue venue;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = venue.networkImageUrl;
    if (url == null || url.isEmpty) {
      return venue.image.image(fit: fit);
    }

    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => venue.image.image(fit: fit),
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : venue.image.image(fit: fit),
    );
  }
}
