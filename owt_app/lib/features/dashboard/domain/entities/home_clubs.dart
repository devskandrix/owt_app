import 'package:equatable/equatable.dart';

import 'club.dart';

/// The four club lists shown on the dashboard, as returned by
/// `GET /clubs/home`.
class HomeClubs extends Equatable {
  final List<Club> trending;
  final List<Club> topClubs;
  final List<Club> nearYou;
  final List<Club> recentlyViewed;

  const HomeClubs({
    required this.trending,
    required this.topClubs,
    required this.nearYou,
    required this.recentlyViewed,
  });

  /// True when every list came back empty — nothing to render.
  bool get isEmpty =>
      trending.isEmpty &&
      topClubs.isEmpty &&
      nearYou.isEmpty &&
      recentlyViewed.isEmpty;

  @override
  List<Object?> get props => [trending, topClubs, nearYou, recentlyViewed];
}
