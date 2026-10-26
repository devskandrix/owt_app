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

  /// Clubs matching [query] (name), optionally filtered by [city] /
  /// [country]; all params optional.
  @GET('/clubs/search')
  Future<ApiListEnvelopeModel> search(
    @Header('Authorization') String bearerToken,
    @Query('q') String? query,
    @Query('city') String? city,
    @Query('country') String? country,
    @Query('limit') int? limit,
    @Query('page') int? page,
  );

  /// Saves a tapped search result to recent searches. Body:
  /// `{ clubId, query? }`. Tapping the same club again moves it to the top
  /// instead of adding a duplicate.
  @POST('/clubs/search/history')
  Future<ApiEnvelopeModel> saveSearchHistory(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );

  /// Recent searches, most recent first; each item embeds its `club`.
  @GET('/clubs/search/history')
  Future<ApiListEnvelopeModel> getSearchHistory(
    @Header('Authorization') String bearerToken,
    @Query('limit') int? limit,
  );

  /// Removes one recent search. 404 if it isn't the user's.
  @DELETE('/clubs/search/history/{historyId}')
  Future<ApiEnvelopeModel> deleteSearchHistory(
    @Header('Authorization') String bearerToken,
    @Path('historyId') String historyId,
  );

  /// Clears every recent search ("Clear All").
  @DELETE('/clubs/search/history')
  Future<ApiEnvelopeModel> clearSearchHistory(
    @Header('Authorization') String bearerToken,
  );

  /// The trending clubs list, capped at [limit] when given.
  @GET('/clubs/trending')
  Future<ApiListEnvelopeModel> getTrending(
    @Header('Authorization') String bearerToken,
    @Query('limit') int? limit,
  );
}
