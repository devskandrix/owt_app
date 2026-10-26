import 'package:equatable/equatable.dart';

import 'club.dart';

/// One recent search from `GET /clubs/search/history`: the club the user
/// tapped and the text they had typed.
class SearchHistoryItem extends Equatable {
  final String id;
  final String? query;
  final DateTime? createdAt;
  final Club club;

  const SearchHistoryItem({
    required this.id,
    required this.club,
    this.query,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, query, createdAt, club];
}
