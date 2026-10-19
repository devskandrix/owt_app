// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(
  Map<String, dynamic> json,
) => AuthUserModel(
  id: json['id'] as String,
  firstName: json['firstName'] as String? ?? '',
  lastName: json['lastName'] as String? ?? '',
  phoneNumber: json['phoneNumber'] as String,
  gender: json['gender'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  hasInterests: json['hasInterests'] as bool? ?? false,
  hasPhotos: json['hasPhotos'] as bool? ?? false,
);

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'gender': instance.gender,
      'photos': instance.photos,
      'interests': instance.interests,
      'hasInterests': instance.hasInterests,
      'hasPhotos': instance.hasPhotos,
    };
