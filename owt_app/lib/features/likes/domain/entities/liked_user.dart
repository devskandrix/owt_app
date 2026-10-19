import 'package:equatable/equatable.dart';

/// Someone who liked the current user's profile, and the club they were
/// at when they did.
class LikedUser extends Equatable {
  final String id;
  final String name;
  final String location;
  final String clubName;

  const LikedUser({
    required this.id,
    required this.name,
    required this.location,
    required this.clubName,
  });

  @override
  List<Object?> get props => [id, name, location, clubName];
}
