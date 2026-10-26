import '../../../../core/network/media_url.dart';
import '../../../matchmaking/data/models/discover_profile_model.dart';
import '../../domain/entities/my_profile.dart';
import '../../domain/entities/profile_interest.dart';

/// Parses a profile: `GET /users/me`'s `data`, and the `user` of
/// `GET /matches` / `GET /matches/:matchId`. Name, photos (primary first)
/// and `bio` reuse [DiscoverProfileModel]'s parsing; `interests` are read
/// here with their emoji icons. The verified badge follows `faceVerified`.
/// There's no tagline field yet, so it stays empty unless one appears.
class MyProfileModel {
  static MyProfile fromJson(Map<String, dynamic> json) {
    final profile = DiscoverProfileModel.fromJson({'user': json});
    return MyProfile(
      id: profile.id,
      fullName: profile.fullName,
      photoUrls: profile.photoUrls,
      primaryPhotoUrl: _primaryPhotoUrl(json['photos']),
      interests: _interests(json['interests']),
      tagline: _string(json['tagline'] ?? json['headline']),
      bio: _string(profile.bio),
      isVerified: json['faceVerified'] == true,
      matchCount: json['matchCount'] is num
          ? (json['matchCount'] as num).toInt()
          : 0,
    );
  }

  /// Interests as names, `{ name, icon }`, or join rows
  /// `{ interest: { name, icon } }`.
  static List<ProfileInterest> _interests(dynamic value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is String && item.trim().isNotEmpty)
          ProfileInterest(name: item.trim())
        else if (item is Map<String, dynamic>)
          if (item['interest'] is Map<String, dynamic>
                  ? item['interest'] as Map<String, dynamic>
                  : item
              case final interest)
            if (_string(interest['name']) case final name?)
              ProfileInterest(
                id: _string(interest['id'] ?? item['interestId']),
                name: name,
                icon: _string(interest['icon']),
              ),
    ];
  }

  /// `imageUrl` of the photo with `isPrimary: true`.
  static String? _primaryPhotoUrl(dynamic photos) {
    if (photos is! List) return null;
    for (final photo in photos.whereType<Map<String, dynamic>>()) {
      if (photo['isPrimary'] != true) continue;
      final url = _string(photo['imageUrl']);
      if (url != null) return resolveMediaUrl(url);
    }
    return null;
  }

  static String? _string(dynamic value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
}
