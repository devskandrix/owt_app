import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/network/models/api_list_envelope_model.dart';

part 'matchmaking_remote_data_source.g.dart';

@RestApi()
abstract class MatchmakingRemoteDataSource {
  factory MatchmakingRemoteDataSource(Dio dio) = _MatchmakingRemoteDataSource;

  /// Checks the user in at a club, granting its Going Tonight badge.
  /// Body: `{ clubId, latitude, longitude }`.
  @POST('/matchmaking/going-tonight')
  Future<ApiEnvelopeModel> checkInGoingTonight(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );

  /// Every club the user currently holds the badge at (`data.sessions`).
  @GET('/matchmaking/going-tonight')
  Future<ApiEnvelopeModel> getGoingTonight(
    @Header('Authorization') String bearerToken,
  );

  /// Joins a club's match-making queue on entering its match screen.
  /// Body: `{ clubId }`. Returns `{ club, session }`.
  @POST('/matchmaking/queue')
  Future<ApiEnvelopeModel> joinQueue(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );

  /// A club's swipe queue — badge holders first, then non-badge visitors.
  /// 400s unless the caller holds the badge at [clubId].
  @GET('/matchmaking/discover')
  Future<ApiListEnvelopeModel> discover(
    @Header('Authorization') String bearerToken,
    @Query('clubId') String clubId,
    @Query('limit') int? limit,
  );

  /// Swipe right. Body: `{ receiverId, clubId }`.
  @POST('/matchmaking/likes')
  Future<ApiEnvelopeModel> like(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );

  /// Swipe left. Body: `{ receiverId, clubId }`; the server records a
  /// `REJECTED` like.
  @POST('/matchmaking/pass')
  Future<ApiEnvelopeModel> pass(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );

  /// People who liked the user, grouped by person; each `clubs[]` entry
  /// carries the `likeId` to accept / decline. Paged via `meta`
  /// (`total`, `page`, `limit`, `totalPages`); [limit] max 50.
  @GET('/matchmaking/likes/received')
  Future<ApiListEnvelopeModel> getReceivedLikes(
    @Header('Authorization') String bearerToken,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Accepts a received like. Returns `{ like, matched, match }`.
  /// 404 if it isn't the user's; 400 if already accepted / declined.
  @POST('/matchmaking/likes/{likeId}/accept')
  Future<ApiEnvelopeModel> acceptLike(
    @Header('Authorization') String bearerToken,
    @Path('likeId') String likeId,
  );

  /// Declines a received like. Same 404 / 400 cases as [acceptLike].
  @DELETE('/matchmaking/likes/{likeId}')
  Future<ApiEnvelopeModel> declineLike(
    @Header('Authorization') String bearerToken,
    @Path('likeId') String likeId,
  );

  /// Blocks [userId]; also deletes any match and likes between the two.
  /// 400 if it's the user's own id; 404 if that user doesn't exist.
  @POST('/users/{userId}/block')
  Future<ApiEnvelopeModel> blockUser(
    @Header('Authorization') String bearerToken,
    @Path('userId') String userId,
  );
}
