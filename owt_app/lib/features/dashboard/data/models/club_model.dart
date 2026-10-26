import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/club.dart';

part 'club_model.g.dart';

/// A club/venue as returned by `GET /clubs/home`, shared by the trending,
/// topClubs, nearYou, and recentlyViewed sections. `score`, `distanceMeters`,
/// and `viewedAt` are section-specific and nullable since only one of them
/// is populated depending on which list the item came from. `matchCount`
/// is only sent by `GET /clubs/search`.
@JsonSerializable(createToJson: false)
class ClubModel {
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
  final int? matchCount;

  /// Whether the current user holds the Going Tonight badge at this club.
  @JsonKey(defaultValue: false)
  final bool isUserVerified;

  const ClubModel({
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
    required this.isUserVerified,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) =>
      _$ClubModelFromJson(json);

  Club toEntity() => Club(
    id: id,
    name: name,
    description: description,
    city: city,
    country: country,
    latitude: latitude,
    longitude: longitude,
    coverImage: coverImage,
    status: status,
    score: score,
    distanceMeters: distanceMeters,
    viewedAt: viewedAt,
    goingTonightNow: goingTonightNow,
    viewCount: viewCount,
    matchCount: matchCount,
    isUserVerified: isUserVerified,
  );
}
