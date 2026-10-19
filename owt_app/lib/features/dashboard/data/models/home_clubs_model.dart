import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/home_clubs.dart';
import 'club_model.dart';

part 'home_clubs_model.g.dart';

/// The `data` payload of `GET /clubs/home`.
@JsonSerializable(createToJson: false)
class HomeClubsModel {
  @JsonKey(defaultValue: [])
  final List<ClubModel> trending;
  @JsonKey(defaultValue: [])
  final List<ClubModel> topClubs;
  @JsonKey(defaultValue: [])
  final List<ClubModel> nearYou;
  @JsonKey(defaultValue: [])
  final List<ClubModel> recentlyViewed;

  const HomeClubsModel({
    required this.trending,
    required this.topClubs,
    required this.nearYou,
    required this.recentlyViewed,
  });

  factory HomeClubsModel.fromJson(Map<String, dynamic> json) =>
      _$HomeClubsModelFromJson(json);

  HomeClubs toEntity() => HomeClubs(
    trending: trending.map((club) => club.toEntity()).toList(),
    topClubs: topClubs.map((club) => club.toEntity()).toList(),
    nearYou: nearYou.map((club) => club.toEntity()).toList(),
    recentlyViewed: recentlyViewed.map((club) => club.toEntity()).toList(),
  );
}
