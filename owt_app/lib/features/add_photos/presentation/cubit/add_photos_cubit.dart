import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/delete_photo.dart';
import '../../domain/usecases/get_my_photos.dart';
import '../../domain/usecases/upload_photo.dart';
import 'add_photos_state.dart';

class AddPhotosCubit extends Cubit<AddPhotosState> {
  AddPhotosCubit(this._getMyPhotos, this._uploadPhoto, this._deletePhoto)
    : super(const AddPhotosState()) {
    load();
  }

  final GetMyPhotos _getMyPhotos;
  final UploadPhoto _uploadPhoto;
  final DeletePhoto _deletePhoto;

  static const maxPhotos = 6;
  static const minRequiredPhotos = 3;
  static const maxUploadBytes = 8 * 1024 * 1024;
  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  Future<void> load() async {
    emit(state.copyWith(loadStatus: PhotosLoadStatus.loading));
    try {
      final photos = await _getMyPhotos(const NoParams());
      emit(state.copyWith(loadStatus: PhotosLoadStatus.loaded, photos: photos));
    } on Failure catch (f) {
      emit(
        state.copyWith(
          loadStatus: PhotosLoadStatus.failure,
          loadErrorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loadStatus: PhotosLoadStatus.failure,
          loadErrorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }

  Future<void> upload(Uint8List bytes, String fileName) async {
    if (state.isUploading || state.photos.length >= maxPhotos) return;

    final extension = fileName.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      emit(
        state.copyWith(actionErrorMessage: AppStrings.unsupportedPhotoFormat),
      );
      return;
    }
    if (bytes.lengthInBytes > maxUploadBytes) {
      emit(state.copyWith(actionErrorMessage: AppStrings.photoTooLarge));
      return;
    }

    emit(state.copyWith(isUploading: true));
    try {
      final photo = await _uploadPhoto(
        UploadPhotoParams(bytes: bytes, fileName: fileName),
      );
      emit(
        state.copyWith(isUploading: false, photos: [...state.photos, photo]),
      );
    } on Failure catch (f) {
      emit(state.copyWith(isUploading: false, actionErrorMessage: f.message));
    } catch (_) {
      emit(
        state.copyWith(
          isUploading: false,
          actionErrorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }

  Future<void> remove(String photoId) async {
    if (state.deletingPhotoIds.contains(photoId)) return;

    emit(
      state.copyWith(deletingPhotoIds: {...state.deletingPhotoIds, photoId}),
    );
    try {
      await _deletePhoto(photoId);
      emit(
        state.copyWith(
          photos: state.photos.where((p) => p.id != photoId).toList(),
          deletingPhotoIds: state.deletingPhotoIds
              .where((id) => id != photoId)
              .toSet(),
        ),
      );
    } on Failure catch (f) {
      emit(
        state.copyWith(
          deletingPhotoIds: state.deletingPhotoIds
              .where((id) => id != photoId)
              .toSet(),
          actionErrorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          deletingPhotoIds: state.deletingPhotoIds
              .where((id) => id != photoId)
              .toSet(),
          actionErrorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
