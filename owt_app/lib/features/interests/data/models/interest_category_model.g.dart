// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestCategoryModel _$InterestCategoryModelFromJson(
  Map<String, dynamic> json,
) => InterestCategoryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String?,
  interests:
      (json['interests'] as List<dynamic>?)
          ?.map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);
