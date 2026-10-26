import 'package:equatable/equatable.dart';

import 'club.dart';

/// The four club lists shown on the dashboard, plus the unread
/// notification count, as returned by `GET /clubs/home`.
class HomeClubs extends Equatable {
  final List<Club> trending;
  final List<Club> topClubs;
  final List<Club> nearYou;
  final List<Club> recentlyViewed;

  /// Unread notifications for the bell badge; null if the server omits it.
  final int? unreadNotificationCount;

  const HomeClubs({
    required this.trending,
    required this.topClubs,
    required this.nearYou,
    required this.recentlyViewed,
    this.unreadNotificationCount,
  });

  /// True when every list came back empty — nothing to render.
  bool get isEmpty =>
      trending.isEmpty &&
      topClubs.isEmpty &&
      nearYou.isEmpty &&
      recentlyViewed.isEmpty;

  @override
  List<Object?> get props => [
    trending,
    topClubs,
    nearYou,
    recentlyViewed,
    unreadNotificationCount,
  ];
}
