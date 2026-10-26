import 'package:equatable/equatable.dart';

import 'discover_profile.dart';

/// A club's swipe queue from `GET /matchmaking/discover` — badge holders
/// and non-badge visitors mixed in one list.
class DiscoverQueue extends Equatable {
  final List<DiscoverProfile> profiles;

  /// `meta.verifiedInterval`: for users without the club's Going Tonight
  /// badge, the Going Tonight promo card shows after every this-many
  /// swipes. Null if the server didn't send one.
  final int? verifiedInterval;

  /// `meta.isCheckedInAtClub`: the user holds this club's Going Tonight
  /// badge.
  final bool isCheckedInAtClub;

  const DiscoverQueue({
    required this.profiles,
    this.verifiedInterval,
    this.isCheckedInAtClub = false,
  });

  @override
  List<Object?> get props => [profiles, verifiedInterval, isCheckedInAtClub];
}
