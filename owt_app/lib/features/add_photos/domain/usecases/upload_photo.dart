import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/photo.dart';
import '../repositories/photos_repository.dart';

class UploadPhoto implements UseCase<Photo, UploadPhotoParams> {
  final PhotosRepository repository;

  const UploadPhoto(this.repository);

  @override
  Future<Photo> call(UploadPhotoParams params) {
    return repository.uploadPhoto(
      bytes: params.bytes,
      fileName: params.fileName,
    );
  }
}

class UploadPhotoParams extends Equatable {
  final Uint8List bytes;
  final String fileName;

  const UploadPhotoParams({required this.bytes, required this.fileName});

  @override
  List<Object?> get props => [bytes, fileName];
}
