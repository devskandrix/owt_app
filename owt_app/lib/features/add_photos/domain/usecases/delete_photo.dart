import '../../../../core/usecase/usecase.dart';
import '../repositories/photos_repository.dart';

class DeletePhoto implements UseCase<void, String> {
  final PhotosRepository repository;

  const DeletePhoto(this.repository);

  @override
  Future<void> call(String photoId) {
    return repository.deletePhoto(photoId);
  }
}
