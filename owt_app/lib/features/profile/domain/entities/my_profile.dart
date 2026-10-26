import 'package:equatable/equatable.dart';

import 'profile_interest.dart';

/// The signed-in user's own profile (`GET /users/me`).
class MyProfile extends Equatable {
  final String id;
  final String fullName;

  /// Photo URLs, primary first, then by display order.
  final List<String> photoUrls;

  /// The photo marked `isPrimary`: the profile avatar and the bottom nav
  /// icon. Null if none is marked.
  final String? primaryPhotoUrl;
  final List<ProfileInterest> interests;

  /// Short one-liner under the name; null when not set.
  final String? tagline;

  /// Longer "about me" text; null when not set.
  final String? bio;
  final bool isVerified;

  /// `matchCount`: shown as "Friends" for now.
  final int matchCount;

  const MyProfile({
    required this.id,
    required this.fullName,
    required this.photoUrls,
    required this.interests,
    this.primaryPhotoUrl,
    this.tagline,
    this.bio,
    this.isVerified = false,
    this.matchCount = 0,
  });

  /// The primary photo, or the first photo if none is marked primary.
  String? get avatarUrl =>
      primaryPhotoUrl ?? (photoUrls.isEmpty ? null : photoUrls.first);

  @override
  List<Object?> get props => [
    id,
    fullName,
    photoUrls,
    primaryPhotoUrl,
    interests,
    tagline,
    bio,
    isVerified,
    matchCount,
  ];
}
