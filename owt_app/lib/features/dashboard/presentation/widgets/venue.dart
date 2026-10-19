import '../../../../core/strings/app_strings.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/club.dart';

/// A club/event card's content, shared by the trending carousel and the
/// Top Clubs / Near You / Recently Viewed horizontal lists.
class Venue {
  const Venue({
    required this.name,
    required this.location,
    required this.image,
    required this.liveCount,
    required this.goingCount,
    this.networkImageUrl,
  });

  final String name;
  final String location;

  /// Placeholder shown while [networkImageUrl] loads, or when it's null/
  /// fails to load (e.g. a [Club] with no `coverImage`).
  final AssetGenImage image;
  final String liveCount;
  final String goingCount;

  /// A club's `coverImage`, when this [Venue] was built from real API data
  /// via [Venue.fromClub]. Null for the static demo venues below, which
  /// render [image] directly.
  final String? networkImageUrl;

  /// Maps a [Club] from `GET /clubs/home` (or `/clubs/trending`) onto the
  /// shape the dashboard's cards render.
  factory Venue.fromClub(Club club) {
    return Venue(
      name: club.name,
      location: [
        club.city,
        club.country,
      ].where((part) => part != null && part.isNotEmpty).join(', '),
      image: Assets.images.venueHero,
      liveCount: _formatCompact(club.viewCount ?? 0),
      goingCount: _formatWithCommas(club.goingTonightNow ?? 0),
      networkImageUrl: club.coverImage,
    );
  }

  static String _formatWithCommas(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String _formatCompact(int value) {
    if (value < 1000) return value.toString();
    final thousands = value / 1000;
    final rounded = (thousands * 10).round() / 10;
    final text = rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(1);
    return '${text}k';
  }

  static final ushuaia = Venue(
    name: AppStrings.venueUshuaiaName,
    location: AppStrings.venueUshuaiaLocation,
    image: Assets.images.venueTeal,
    liveCount: AppStrings.venueUshuaiaLiveCount,
    goingCount: AppStrings.venueUshuaiaGoingCount,
  );

  static final lordOfTheDrinks = Venue(
    name: AppStrings.venueLordOfDrinksName,
    location: AppStrings.venueLordOfDrinksLocationListing,
    image: Assets.images.venueHero,
    liveCount: AppStrings.venueLordOfDrinksLiveCount,
    goingCount: AppStrings.venueLordOfDrinksGoingCount,
  );

  static final lordOfTheDrinksTrending = Venue(
    name: AppStrings.venueLordOfDrinksName,
    location: AppStrings.venueLordOfDrinksLocationTrending,
    image: Assets.images.venueHero,
    liveCount: AppStrings.venueLordOfDrinksLiveCount,
    goingCount: AppStrings.venueLordOfDrinksGoingCountTrending,
  );

  /// The reused 3-item ordering seen in every horizontal list on the
  /// dashboard (Top Clubs, Near You, Recently Viewed).
  static List<Venue> listing() => [ushuaia, lordOfTheDrinks, lordOfTheDrinks];

  /// The trending carousel's 3 cards: identical copy (matching the Figma
  /// source, which reuses the same placeholder text for all three), with
  /// the vivid hero photo centered and the teal photo peeking on either
  /// side.
  static List<Venue> trending() => [
    Venue(
      name: lordOfTheDrinksTrending.name,
      location: lordOfTheDrinksTrending.location,
      image: Assets.images.venueTeal,
      liveCount: lordOfTheDrinksTrending.liveCount,
      goingCount: lordOfTheDrinksTrending.goingCount,
    ),
    lordOfTheDrinksTrending,
    Venue(
      name: lordOfTheDrinksTrending.name,
      location: lordOfTheDrinksTrending.location,
      image: Assets.images.venueTeal,
      liveCount: lordOfTheDrinksTrending.liveCount,
      goingCount: lordOfTheDrinksTrending.goingCount,
    ),
  ];

  /// The search screen's 3 result rows: identical copy (again matching
  /// the Figma source's reused placeholder text), alternating the hero and
  /// teal photos for visual variety.
  static List<Venue> searchResults() => [
    lordOfTheDrinksTrending,
    Venue(
      name: lordOfTheDrinksTrending.name,
      location: lordOfTheDrinksTrending.location,
      image: Assets.images.venueTeal,
      liveCount: lordOfTheDrinksTrending.liveCount,
      goingCount: lordOfTheDrinksTrending.goingCount,
    ),
    lordOfTheDrinksTrending,
  ];
}
