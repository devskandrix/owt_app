import '../../../../core/usecase/usecase.dart';
import '../entities/photo.dart';
import '../repositories/photos_repository.dart';

class GetMyPhotos implements UseCase<List<Photo>, NoParams> {
  final PhotosRepository repository;

  const GetMyPhotos(this.repository);

  @override
  Future<List<Photo>> call(NoParams params) {
    return repository.getMyPhotos();
  }
}
