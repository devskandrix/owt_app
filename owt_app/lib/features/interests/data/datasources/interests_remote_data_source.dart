import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/network/models/api_list_envelope_model.dart';
import '../models/update_interests_request_model.dart';

part 'interests_remote_data_source.g.dart';

@RestApi()
abstract class InterestsRemoteDataSource {
  factory InterestsRemoteDataSource(Dio dio) = _InterestsRemoteDataSource;

  /// The interest categories to render, each with its pill options.
  @GET('/interests')
  Future<ApiListEnvelopeModel> getInterests(
    @Header('Authorization') String bearerToken,
  );

  /// Persists the user's selected interest ids (3-5 total).
  @PUT('/users/me/interests')
  Future<ApiEnvelopeModel> updateInterests(
    @Header('Authorization') String bearerToken,
    @Body() UpdateInterestsRequestModel body,
  );
}
