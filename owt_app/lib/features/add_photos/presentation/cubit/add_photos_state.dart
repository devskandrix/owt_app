import 'package:equatable/equatable.dart';

import '../../domain/entities/photo.dart';

enum PhotosLoadStatus { loading, loaded, failure }

class AddPhotosState extends Equatable {
  final PhotosLoadStatus loadStatus;
  final String? loadErrorMessage;
  final List<Photo> photos;
  final bool isUploading;
  final Set<String> deletingPhotoIds;
  final String? actionErrorMessage;

  /// The photo being swapped for a new one, shown with a spinner.
  final String? replacingPhotoId;

  const AddPhotosState({
    this.loadStatus = PhotosLoadStatus.loading,
    this.loadErrorMessage,
    this.photos = const [],
    this.isUploading = false,
    this.deletingPhotoIds = const {},
    this.actionErrorMessage,
    this.replacingPhotoId,
  });

  /// Photos that will remain once in-flight deletes finish.
  int get keptPhotoCount => photos.length - deletingPhotoIds.length;

  bool get isBusy => isUploading || replacingPhotoId != null;

  AddPhotosState copyWith({
    PhotosLoadStatus? loadStatus,
    String? loadErrorMessage,
    List<Photo>? photos,
    bool? isUploading,
    Set<String>? deletingPhotoIds,
    String? actionErrorMessage,
    String? replacingPhotoId,
    bool clearReplacing = false,
  }) {
    return AddPhotosState(
      loadStatus: loadStatus ?? this.loadStatus,
      loadErrorMessage: loadErrorMessage,
      photos: photos ?? this.photos,
      isUploading: isUploading ?? this.isUploading,
      deletingPhotoIds: deletingPhotoIds ?? this.deletingPhotoIds,
      actionErrorMessage: actionErrorMessage,
      replacingPhotoId: clearReplacing
          ? null
          : replacingPhotoId ?? this.replacingPhotoId,
    );
  }

  @override
  List<Object?> get props => [
    loadStatus,
    loadErrorMessage,
    photos,
    isUploading,
    deletingPhotoIds,
    actionErrorMessage,
    replacingPhotoId,
  ];
}
