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

  const AddPhotosState({
    this.loadStatus = PhotosLoadStatus.loading,
    this.loadErrorMessage,
    this.photos = const [],
    this.isUploading = false,
    this.deletingPhotoIds = const {},
    this.actionErrorMessage,
  });

  AddPhotosState copyWith({
    PhotosLoadStatus? loadStatus,
    String? loadErrorMessage,
    List<Photo>? photos,
    bool? isUploading,
    Set<String>? deletingPhotoIds,
    String? actionErrorMessage,
  }) {
    return AddPhotosState(
      loadStatus: loadStatus ?? this.loadStatus,
      loadErrorMessage: loadErrorMessage,
      photos: photos ?? this.photos,
      isUploading: isUploading ?? this.isUploading,
      deletingPhotoIds: deletingPhotoIds ?? this.deletingPhotoIds,
      actionErrorMessage: actionErrorMessage,
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
  ];
}
