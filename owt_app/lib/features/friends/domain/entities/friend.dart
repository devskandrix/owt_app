import 'package:equatable/equatable.dart';

import '../../../profile/domain/entities/my_profile.dart';

/// One of the user's matches (`GET /matches`), shown as a friend.
class Friend extends Equatable {
  final String matchId;
  final String userId;
  final String name;
  final String? location;
  final String? avatarUrl;
  final String? clubName;
  final String? clubImageUrl;
  final DateTime? matchedAt;

  /// The full profile from the list response (photos, interests, bio),
  /// so their profile page can show it right away.
  final MyProfile profile;

  const Friend({
    required this.matchId,
    required this.userId,
    required this.name,
    required this.profile,
    this.location,
    this.avatarUrl,
    this.clubName,
    this.clubImageUrl,
    this.matchedAt,
  });

  @override
  List<Object?> get props => [
    matchId,
    userId,
    name,
    location,
    avatarUrl,
    clubName,
    clubImageUrl,
    matchedAt,
    profile,
  ];
}
