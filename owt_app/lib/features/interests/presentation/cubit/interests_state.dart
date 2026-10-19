import 'package:equatable/equatable.dart';

import '../../domain/entities/interest_category.dart';

enum InterestsLoadStatus { loading, loaded, failure }

enum InterestsSubmitStatus { idle, loading, success, failure }

class InterestsState extends Equatable {
  final InterestsLoadStatus loadStatus;
  final List<InterestCategory> categories;
  final String? loadErrorMessage;
  final Set<String> selectedIds;
  final InterestsSubmitStatus submitStatus;
  final String? submitErrorMessage;

  const InterestsState({
    this.loadStatus = InterestsLoadStatus.loading,
    this.categories = const [],
    this.loadErrorMessage,
    this.selectedIds = const {},
    this.submitStatus = InterestsSubmitStatus.idle,
    this.submitErrorMessage,
  });

  InterestsState copyWith({
    InterestsLoadStatus? loadStatus,
    List<InterestCategory>? categories,
    String? loadErrorMessage,
    Set<String>? selectedIds,
    InterestsSubmitStatus? submitStatus,
    String? submitErrorMessage,
  }) {
    return InterestsState(
      loadStatus: loadStatus ?? this.loadStatus,
      categories: categories ?? this.categories,
      loadErrorMessage: loadErrorMessage,
      selectedIds: selectedIds ?? this.selectedIds,
      submitStatus: submitStatus ?? this.submitStatus,
      submitErrorMessage: submitErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    categories,
    loadErrorMessage,
    selectedIds,
    submitStatus,
    submitErrorMessage,
  ];
}
