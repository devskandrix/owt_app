import 'package:equatable/equatable.dart';

/// One person in a club's swipe queue (`GET /matchmaking/discover`).
class DiscoverProfile extends Equatable {
  final String id;
  final String fullName;
  final List<String> photoUrls;
  final List<String> interests;
  final String? bio;

  /// Has the Going Tonight badge at this club right now.
  final bool isGoingTonight;

  const DiscoverProfile({
    required this.id,
    required this.fullName,
    required this.photoUrls,
    required this.interests,
    required this.isGoingTonight,
    this.bio,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    photoUrls,
    interests,
    bio,
    isGoingTonight,
  ];
}
