import 'package:equatable/equatable.dart';

import 'club.dart';

/// One page of `GET /clubs/search` results plus its pagination meta.
class ClubSearchPage extends Equatable {
  final List<Club> clubs;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ClubSearchPage({
    required this.clubs,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [clubs, total, page, limit, totalPages];
}
