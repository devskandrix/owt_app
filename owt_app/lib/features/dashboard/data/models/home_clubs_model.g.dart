// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_clubs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeClubsModel _$HomeClubsModelFromJson(Map<String, dynamic> json) =>
    HomeClubsModel(
      trending:
          (json['trending'] as List<dynamic>?)
              ?.map((e) => ClubModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topClubs:
          (json['topClubs'] as List<dynamic>?)
              ?.map((e) => ClubModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nearYou:
          (json['nearYou'] as List<dynamic>?)
              ?.map((e) => ClubModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentlyViewed:
          (json['recentlyViewed'] as List<dynamic>?)
              ?.map((e) => ClubModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      unreadNotificationCount: (json['unreadNotificationCount'] as num?)
          ?.toInt(),
    );
