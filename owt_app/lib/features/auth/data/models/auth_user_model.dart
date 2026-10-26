import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  final String id;
  @JsonKey(defaultValue: '')
  final String firstName;
  @JsonKey(defaultValue: '')
  final String lastName;
  final String phoneNumber;
  final String? gender;
  @JsonKey(defaultValue: [])
  final List<String> photos;
  @JsonKey(defaultValue: [])
  final List<String> interests;
  @JsonKey(defaultValue: false)
  final bool hasInterests;
  @JsonKey(defaultValue: false)
  final bool hasPhotos;

  const AuthUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    required this.photos,
    required this.interests,
    required this.hasInterests,
    required this.hasPhotos,
  });

  /// `/auth/social/:provider` returns `firstName`/`lastName` directly, but
  /// `/auth/register` returns a single `fullName` instead — split it into
  /// the two here so both endpoints can share this model.
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    if (json['firstName'] == null && json['fullName'] is String) {
      final parts = (json['fullName'] as String).trim().split(RegExp(r'\s+'));
      json = {
        ...json,
        'firstName': parts.isNotEmpty ? parts.first : '',
        'lastName': parts.length > 1 ? parts.skip(1).join(' ') : '',
      };
    }
    // `photos`/`interests` come back as lists of full objects (photo
    // records, interest join rows), not plain strings — reduce each to its
    // id so this model, which only needs to know *which* ones, stays a
    // simple `List<String>`.
    json = {
      ...json,
      'photos': _idsOf(json['photos'], key: 'id'),
      'interests': _idsOf(
        json['interests'],
        key: 'interestId',
        fallbackKey: 'id',
      ),
    };
    return _$AuthUserModelFromJson(json);
  }

  static List<String>? _idsOf(
    dynamic value, {
    required String key,
    String? fallbackKey,
  }) {
    if (value is! List) return null;
    return value.map((e) {
      if (e is String) return e;
      if (e is Map<String, dynamic>) {
        return (e[key] ?? (fallbackKey != null ? e[fallbackKey] : null))
            .toString();
      }
      return e.toString();
    }).toList();
  }

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  AuthUser toEntity() => AuthUser(
    id: id,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber,
    gender: gender,
    photos: photos,
    interests: interests,
    hasInterests: hasInterests,
    hasPhotos: hasPhotos,
  );
}
