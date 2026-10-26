import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/search_history_item.dart';
import 'club_model.dart';

part 'search_history_item_model.g.dart';

/// An item of `GET /clubs/search/history`'s `data` list.
@JsonSerializable(createToJson: false)
class SearchHistoryItemModel {
  final String id;
  final String? query;
  final DateTime? createdAt;
  final ClubModel club;

  const SearchHistoryItemModel({
    required this.id,
    required this.club,
    this.query,
    this.createdAt,
  });

  factory SearchHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryItemModelFromJson(json);

  SearchHistoryItem toEntity() => SearchHistoryItem(
    id: id,
    query: query,
    createdAt: createdAt,
    club: club.toEntity(),
  );
}
