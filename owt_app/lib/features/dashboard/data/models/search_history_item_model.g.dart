// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryItemModel _$SearchHistoryItemModelFromJson(
  Map<String, dynamic> json,
) => SearchHistoryItemModel(
  id: json['id'] as String,
  club: ClubModel.fromJson(json['club'] as Map<String, dynamic>),
  query: json['query'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);
