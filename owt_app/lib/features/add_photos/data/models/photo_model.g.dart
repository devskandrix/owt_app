// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) => PhotoModel(
  id: json['id'] as String,
  imageUrl: json['imageUrl'] as String,
  displayOrder: (json['displayOrder'] as num).toInt(),
  isPrimary: json['isPrimary'] as bool,
);
