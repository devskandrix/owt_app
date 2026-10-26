// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClubModel _$ClubModelFromJson(Map<String, dynamic> json) => ClubModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  coverImage: json['coverImage'] as String?,
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
  distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
  viewedAt: json['viewedAt'] == null
      ? null
      : DateTime.parse(json['viewedAt'] as String),
  goingTonightNow: (json['goingTonightNow'] as num?)?.toInt(),
  viewCount: (json['viewCount'] as num?)?.toInt(),
  matchCount: (json['matchCount'] as num?)?.toInt(),
  isUserVerified: json['isUserVerified'] as bool? ?? false,
);
