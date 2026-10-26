import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../matchmaking/domain/entities/received_like.dart';
import '../../../matchmaking/domain/usecases/accept_like.dart';
import '../../../matchmaking/domain/usecases/decline_like.dart';
import '../../../matchmaking/domain/usecases/get_received_likes.dart';
import 'likes_state.dart';

/// The Likes tab.
///
/// Loads `GET /matchmaking/likes/received` a page at a time. Confirm sends
/// `POST /matchmaking/likes/:likeId/accept` and turns the row into the
/// "It’s Match" banner; X sends `DELETE /matchmaking/likes/:likeId` and
/// removes the row straight away (put back if the request fails).
class LikesCubit extends Cubit<LikesState> {
  LikesCubit(this._getReceivedLikes, this._acceptLike, this._declineLike)
    : super(const LikesState());

  final GetReceivedLikes _getReceivedLikes;
  final AcceptLike _acceptLike;
  final DeclineLike _declineLike;

  static const int _pageSize = 20;

  final _notices = StreamController<LikesNotice>.broadcast();

  /// Errors from accept / decline, for the page to show as a notice.
  Stream<LikesNotice> get notices => _notices.stream;

  /// First page: on open, pull-to-refresh, and retry.
  Future<void> load() async {
    if (state.likes.isEmpty) {
      emit(state.copyWith(status: LikesStatus.loading));
    }
    try {
      final result = await _getReceivedLikes(
        const GetReceivedLikesParams(limit: _pageSize),
      );
      if (isClosed) return;
      emit(
        LikesState(
          status: LikesStatus.ready,
          likes: result.likes,
          totalLikes: result.total,
          page: result.page,
          hasMore: result.hasMore,
        ),
      );
    } on Failure catch (f) {
      _failLoad(f.message);
    } catch (_) {
      _failLoad(AppStrings.somethingWentWrong);
    }
  }

  /// Next page, when the list is scrolled near its end.
  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    if (state.status != LikesStatus.ready) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final result = await _getReceivedLikes(
        GetReceivedLikesParams(page: state.page + 1, limit: _pageSize),
      );
      if (isClosed) return;
      // Rows removed since page 1 shift later pages back, so skip any
      // like already on screen.
      final known = {for (final like in state.likes) like.likeId};
      emit(
        state.copyWith(
          likes: [
            ...state.likes,
            ...result.likes.where((like) => !known.contains(like.likeId)),
          ],
          totalLikes: result.total,
          page: result.page,
          hasMore: result.hasMore,
          loadingMore: false,
        ),
      );
    } catch (_) {
      if (!isClosed) emit(state.copyWith(loadingMore: false));
    }
  }

  /// Confirm: accepts the like and shows the "It’s Match" banner in its
  /// place.
  Future<void> accept(String likeId) async {
    if (state.busyIds.contains(likeId)) return;
    emit(state.copyWith(busyIds: {...state.busyIds, likeId}));
    try {
      final result = await _acceptLike(likeId);
      if (isClosed) return;
      final busy = {...state.busyIds}..remove(likeId);
      if (result.matched) {
        emit(
          state.copyWith(
            busyIds: busy,
            matchedIds: {...state.matchedIds, likeId},
            totalLikes: _decrementedTotal,
          ),
        );
      } else {
        emit(state.copyWith(busyIds: busy));
        _removeRow(likeId);
      }
    } on Failure catch (f) {
      _handleActionFailure(likeId, f);
    } catch (_) {
      _handleActionFailure(likeId, null);
    }
  }

  /// X: declines the like. The row goes right away and comes back if the
  /// request fails.
  Future<void> decline(String likeId) async {
    final index = state.likes.indexWhere((like) => like.likeId == likeId);
    if (index < 0 || state.busyIds.contains(likeId)) return;
    final like = state.likes[index];
    _removeRow(likeId);
    try {
      await _declineLike(likeId);
    } on Failure catch (f) {
      if (_alreadyHandled(f)) return;
      _restoreRow(like, index);
      _notify(f.message);
    } catch (_) {
      _restoreRow(like, index);
      _notify(AppStrings.somethingWentWrong);
    }
  }

  /// The match banner's X: hides it (the like was already accepted).
  void dismissMatch(String likeId) {
    emit(
      state.copyWith(
        likes: state.likes.where((like) => like.likeId != likeId).toList(),
        matchedIds: {...state.matchedIds}..remove(likeId),
      ),
    );
  }

  int get _decrementedTotal => state.totalLikes > 0 ? state.totalLikes - 1 : 0;

  void _removeRow(String likeId) {
    if (isClosed) return;
    emit(
      state.copyWith(
        likes: state.likes.where((like) => like.likeId != likeId).toList(),
        totalLikes: _decrementedTotal,
      ),
    );
  }

  void _restoreRow(ReceivedLike like, int index) {
    if (isClosed) return;
    final likes = [...state.likes];
    likes.insert(index.clamp(0, likes.length), like);
    emit(state.copyWith(likes: likes, totalLikes: state.totalLikes + 1));
  }

  /// 404 / 400 mean the like is gone or already decided (e.g. from
  /// another device): just drop the row.
  bool _alreadyHandled(Failure f) =>
      f is ServerFailure && (f.statusCode == 400 || f.statusCode == 404);

  void _handleActionFailure(String likeId, Failure? f) {
    if (isClosed) return;
    emit(state.copyWith(busyIds: {...state.busyIds}..remove(likeId)));
    if (f != null && _alreadyHandled(f)) {
      _removeRow(likeId);
      return;
    }
    _notify(f?.message ?? AppStrings.somethingWentWrong);
  }

  void _notify(String message) {
    if (!_notices.isClosed) _notices.add(LikesErrorNotice(message));
  }

  void _failLoad(String message) {
    if (isClosed) return;
    // Keep showing what's loaded if a refresh fails.
    if (state.likes.isNotEmpty) {
      _notify(message);
      emit(state.copyWith(status: LikesStatus.ready));
      return;
    }
    emit(state.copyWith(status: LikesStatus.failure, errorMessage: message));
  }

  @override
  Future<void> close() {
    _notices.close();
    return super.close();
  }
}
