import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';

part 'photos_remote_data_source.g.dart';

/// The photo upload itself (`POST /users/me/photos`) is a multipart request
/// built from raw bytes so it works on every platform, including web — it's
/// issued directly through [Dio] in `PhotosRepositoryImpl` rather than
/// through this retrofit interface.
@RestApi()
abstract class PhotosRemoteDataSource {
  factory PhotosRemoteDataSource(Dio dio) = _PhotosRemoteDataSource;

  /// The signed-in user's full profile, including their photos.
  @GET('/users/me')
  Future<ApiEnvelopeModel> getMe(@Header('Authorization') String bearerToken);

  @DELETE('/users/me/photos/{photoId}')
  Future<ApiEnvelopeModel> deletePhoto(
    @Header('Authorization') String bearerToken,
    @Path('photoId') String photoId,
  );
}
