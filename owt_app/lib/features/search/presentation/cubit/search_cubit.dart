import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../dashboard/domain/entities/club.dart';
import '../../../dashboard/domain/entities/search_history_item.dart';
import '../../../dashboard/domain/usecases/clear_search_history.dart';
import '../../../dashboard/domain/usecases/delete_search_history.dart';
import '../../../dashboard/domain/usecases/get_search_history.dart';
import '../../../dashboard/domain/usecases/save_search_history.dart';
import '../../../dashboard/domain/usecases/search_clubs.dart';
import 'search_state.dart';

/// Club search via `GET /clubs/search`, plus recent searches
/// (`/clubs/search/history`). Typing is debounced, results are paged with
/// [loadMore], and a response for a query the user has since changed is
/// dropped. A search is only saved to history when the user opens a result
/// ([openedClub]), not on every keystroke.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._searchClubs,
    this._getHistory,
    this._saveHistory,
    this._deleteHistory,
    this._clearHistory,
  ) : super(const SearchState()) {
    _run('');
    loadHistory();
  }

  final SearchClubs _searchClubs;
  final GetSearchHistory _getHistory;
  final SaveSearchHistory _saveHistory;
  final DeleteSearchHistory _deleteHistory;
  final ClearSearchHistory _clearHistory;
  Timer? _debounce;

  /// Bumped on every new query so in-flight page loads for an older query
  /// can tell they are stale.
  int _generation = 0;

  static const Duration _debounceDelay = Duration(milliseconds: 350);
  static const int _limit = 20;
  static const int _historyLimit = 20;

  void queryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, () {
      final trimmed = query.trim();
      if (trimmed == state.query && state.status == SearchStatus.loaded) {
        return;
      }
      _run(trimmed);
    });
  }

  Future<void> retry() => _run(state.query);

  /// Fetches the next page for the current query, if there is one.
  Future<void> loadMore() async {
    if (state.status != SearchStatus.loaded ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    final generation = _generation;
    final current = state;
    emit(current.copyWith(isLoadingMore: true));
    try {
      final page = await _searchClubs(
        SearchClubsParams(
          query: current.query.isEmpty ? null : current.query,
          limit: _limit,
          page: current.page + 1,
        ),
      );
      if (isClosed || generation != _generation) return;
      final seen = {for (final c in current.results) c.id};
      emit(
        state.copyWith(
          results: [
            ...current.results,
            ...page.clubs.where((c) => seen.add(c.id)),
          ],
          page: page.page,
          hasMore: page.hasMore,
          total: page.total,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      // Keep what's shown; scrolling to the end again retries.
      if (isClosed || generation != _generation) return;
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  // -------------------------------------------------------------------
  // Recent searches
  // -------------------------------------------------------------------

  /// Loads recent searches. Failures leave the list as it was — history
  /// is a convenience and shouldn't block searching.
  Future<void> loadHistory() async {
    try {
      final history = await _getHistory(
        const GetSearchHistoryParams(limit: _historyLimit),
      );
      if (!isClosed) emit(state.copyWith(history: history));
    } catch (_) {}
  }

  /// The user opened [club] from search results or Recent. Moves it to the
  /// top of Recent right away, then saves it and reloads the list so it has
  /// the server's id. [query] is the text they had typed, if any.
  Future<void> openedClub(Club club, {String? query}) async {
    final typed = query?.trim();
    final existing = state.history.where((h) => h.club.id == club.id);
    if (existing.isNotEmpty) {
      emit(
        state.copyWith(
          history: [
            existing.first,
            ...state.history.where((h) => h.club.id != club.id),
          ],
        ),
      );
    }
    try {
      await _saveHistory(
        SaveSearchHistoryParams(
          clubId: club.id,
          query: (typed == null || typed.isEmpty) ? null : typed,
        ),
      );
      await loadHistory();
    } catch (_) {
      // Not saving a recent search isn't worth interrupting the user.
    }
  }

  /// Removes one recent search, restoring it if the server call fails.
  Future<void> removeHistory(String historyId) async {
    final before = state.history;
    emit(
      state.copyWith(history: before.where((h) => h.id != historyId).toList()),
    );
    try {
      await _deleteHistory(historyId);
    } on Failure catch (f) {
      _restoreHistory(before, f.message);
    } catch (_) {
      _restoreHistory(before, AppStrings.somethingWentWrong);
    }
  }

  /// Clears every recent search, restoring them if the server call fails.
  Future<void> clearHistory() async {
    final before = state.history;
    if (before.isEmpty) return;
    emit(state.copyWith(history: const []));
    try {
      await _clearHistory(const NoParams());
    } on Failure catch (f) {
      _restoreHistory(before, f.message);
    } catch (_) {
      _restoreHistory(before, AppStrings.somethingWentWrong);
    }
  }

  void _restoreHistory(List<SearchHistoryItem> before, String message) {
    if (isClosed) return;
    emit(state.copyWith(history: before, notice: message));
  }

  // -------------------------------------------------------------------

  Future<void> _run(String query) async {
    final generation = ++_generation;
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        isLoadingMore: false,
      ),
    );
    try {
      final page = await _searchClubs(
        SearchClubsParams(
          query: query.isEmpty ? null : query,
          limit: _limit,
          page: 1,
        ),
      );
      if (isClosed || generation != _generation) return;
      emit(
        state.copyWith(
          status: SearchStatus.loaded,
          results: page.clubs,
          page: page.page,
          hasMore: page.hasMore,
          total: page.total,
        ),
      );
    } on Failure catch (f) {
      _fail(generation, f.message);
    } catch (_) {
      _fail(generation, AppStrings.somethingWentWrong);
    }
  }

  void _fail(int generation, String message) {
    if (isClosed || generation != _generation) return;
    emit(
      state.copyWith(
        status: SearchStatus.failure,
        results: const [],
        page: 0,
        hasMore: false,
        errorMessage: message,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
