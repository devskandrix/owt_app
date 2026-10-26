import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';

part 'zego_token_remote_data_source.g.dart';

@RestApi()
abstract class ZegoTokenRemoteDataSource {
  factory ZegoTokenRemoteDataSource(Dio dio) = _ZegoTokenRemoteDataSource;

  /// `data`: `{ token, expiresAt }`. The token's user id is the caller's
  /// own (from the access token), never one sent by the app.
  @GET('/zego/token')
  Future<ApiEnvelopeModel> getToken(
    @Header('Authorization') String bearerToken,
  );
}
