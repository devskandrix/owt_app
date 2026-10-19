import 'package:equatable/equatable.dart';

/// The authenticated user's profile, as returned by our backend for an
/// already-registered user (`data.user` on a `/auth/social/:provider`
/// response that doesn't need registration).
class AuthUser extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? gender;
  final List<String> photos;
  final List<String> interests;
  final bool hasInterests;
  final bool hasPhotos;

  const AuthUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    this.photos = const [],
    this.interests = const [],
    this.hasInterests = false,
    this.hasPhotos = false,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phoneNumber,
    gender,
    photos,
    interests,
    hasInterests,
    hasPhotos,
  ];
}
