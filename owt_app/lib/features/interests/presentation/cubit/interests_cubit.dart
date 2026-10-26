import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_interests.dart';
import '../../domain/usecases/update_selected_interests.dart';
import 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  InterestsCubit(this._getInterests, this._updateSelectedInterests)
    : super(const InterestsState()) {
    load();
  }

  final GetInterests _getInterests;
  final UpdateSelectedInterests _updateSelectedInterests;

  static const minSelected = 3;
  static const maxSelected = 5;

  Future<void> load() async {
    emit(state.copyWith(loadStatus: InterestsLoadStatus.loading));
    try {
      final categories = await _getInterests(const NoParams());
      emit(
        state.copyWith(
          loadStatus: InterestsLoadStatus.loaded,
          categories: categories,
        ),
      );
    } on Failure catch (f) {
      emit(
        state.copyWith(
          loadStatus: InterestsLoadStatus.failure,
          loadErrorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loadStatus: InterestsLoadStatus.failure,
          loadErrorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }

  /// Starts with [ids] selected, e.g. the user's current interests when
  /// editing them from Profile.
  void preselect(Set<String> ids) {
    emit(state.copyWith(selectedIds: Set<String>.of(ids)));
  }

  /// Returns false (without changing the selection) if [interestId] wasn't
  /// already selected and the cap of [maxSelected] has been reached.
  bool toggle(String interestId) {
    final updated = Set<String>.of(state.selectedIds);
    if (!updated.remove(interestId)) {
      if (updated.length >= maxSelected) return false;
      updated.add(interestId);
    }
    emit(state.copyWith(selectedIds: updated));
    return true;
  }

  Future<void> submit() async {
    if (state.selectedIds.length < minSelected) return;

    emit(state.copyWith(submitStatus: InterestsSubmitStatus.loading));
    try {
      await _updateSelectedInterests(
        UpdateSelectedInterestsParams(state.selectedIds.toList()),
      );
      emit(state.copyWith(submitStatus: InterestsSubmitStatus.success));
    } on Failure catch (f) {
      emit(
        state.copyWith(
          submitStatus: InterestsSubmitStatus.failure,
          submitErrorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          submitStatus: InterestsSubmitStatus.failure,
          submitErrorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
