import 'package:equatable/equatable.dart';

/// A club/venue, as returned by `GET /clubs/home` and `GET /clubs/trending`.
/// `score`, `distanceMeters`, and `viewedAt` are only populated on the
/// section a given instance came from (trending/topClubs, nearYou, and
/// recentlyViewed respectively).
class Club extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? coverImage;
  final String? status;
  final int? score;
  final double? distanceMeters;
  final DateTime? viewedAt;
  final int? goingTonightNow;
  final int? viewCount;

  /// Matches at this club; only sent by `GET /clubs/search`.
  final int? matchCount;

  /// Whether the current user holds the Going Tonight badge here — decides
  /// whether opening the club goes straight to its swipe queue.
  final bool isUserVerified;

  const Club({
    required this.id,
    required this.name,
    this.description,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.coverImage,
    this.status,
    this.score,
    this.distanceMeters,
    this.viewedAt,
    this.goingTonightNow,
    this.viewCount,
    this.matchCount,
    this.isUserVerified = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    city,
    country,
    latitude,
    longitude,
    coverImage,
    status,
    score,
    distanceMeters,
    viewedAt,
    goingTonightNow,
    viewCount,
    matchCount,
    isUserVerified,
  ];
}
