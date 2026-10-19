import 'dart:typed_data';

import '../entities/photo.dart';

abstract class PhotosRepository {
  /// The signed-in user's photos, via `GET /users/me`.
  Future<List<Photo>> getMyPhotos();

  /// Uploads [bytes] (named [fileName], used to infer its content type) as
  /// a new photo via `POST /users/me/photos`.
  Future<Photo> uploadPhoto({
    required Uint8List bytes,
    required String fileName,
  });

  /// Deletes a photo via `DELETE /users/me/photos/:photoId`.
  Future<void> deletePhoto(String photoId);
}
