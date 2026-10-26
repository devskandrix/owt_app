import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';

part 'profile_remote_data_source.g.dart';

@RestApi()
abstract class ProfileRemoteDataSource {
  factory ProfileRemoteDataSource(Dio dio) = _ProfileRemoteDataSource;

  /// The signed-in user's full profile, including their photos.
  @GET('/users/me')
  Future<ApiEnvelopeModel> getMe(@Header('Authorization') String bearerToken);

  /// Soft-deletes (deactivates) the signed-in user's account.
  @DELETE('/users/me')
  Future<ApiEnvelopeModel> deactivateMe(
    @Header('Authorization') String bearerToken,
  );
}
