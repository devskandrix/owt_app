import 'package:equatable/equatable.dart';

import '../../../dashboard/domain/entities/club.dart';
import '../../../dashboard/domain/entities/search_history_item.dart';

enum SearchStatus { loading, loaded, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<Club> results;
  final String? errorMessage;

  /// Last page loaded for [query] (0 before the first page arrives).
  final int page;

  /// Whether the server has more pages after [page].
  final bool hasMore;

  /// True while the next page is being fetched.
  final bool isLoadingMore;

  /// Total matches across all pages, from the response's `meta.total`.
  final int total;

  /// Recent searches, most recent first. Shown while [query] is empty.
  final List<SearchHistoryItem> history;

  /// One-off message for a failed history action (remove / clear), shown
  /// as a notice. Cleared by the next state change.
  final String? notice;

  const SearchState({
    this.status = SearchStatus.loading,
    this.query = '',
    this.results = const [],
    this.errorMessage,
    this.page = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.total = 0,
    this.history = const [],
    this.notice,
  });

  /// Copies this state. [errorMessage] and [notice] are not carried over
  /// unless passed again.
  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Club>? results,
    String? errorMessage,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    int? total,
    List<SearchHistoryItem>? history,
    String? notice,
  }) => SearchState(
    status: status ?? this.status,
    query: query ?? this.query,
    results: results ?? this.results,
    errorMessage: errorMessage,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    total: total ?? this.total,
    history: history ?? this.history,
    notice: notice,
  );

  @override
  List<Object?> get props => [
    status,
    query,
    results,
    errorMessage,
    page,
    hasMore,
    isLoadingMore,
    total,
    history,
    notice,
  ];
}
