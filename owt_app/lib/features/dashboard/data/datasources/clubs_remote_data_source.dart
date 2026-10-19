import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/network/models/api_list_envelope_model.dart';

part 'clubs_remote_data_source.g.dart';

@RestApi()
abstract class ClubsRemoteDataSource {
  factory ClubsRemoteDataSource(Dio dio) = _ClubsRemoteDataSource;

  /// The dashboard's trending/topClubs/nearYou/recentlyViewed lists.
  /// [latitude]/[longitude] are optional and improve `nearYou` ordering.
  @GET('/clubs/home')
  Future<ApiEnvelopeModel> getHome(
    @Header('Authorization') String bearerToken,
    @Query('latitude') double? latitude,
    @Query('longitude') double? longitude,
  );

  /// The trending clubs list, capped at [limit] when given.
  @GET('/clubs/trending')
  Future<ApiListEnvelopeModel> getTrending(
    @Header('Authorization') String bearerToken,
    @Query('limit') int? limit,
  );
}
