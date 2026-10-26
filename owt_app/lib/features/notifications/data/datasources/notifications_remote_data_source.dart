import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/network/models/api_list_envelope_model.dart';

part 'notifications_remote_data_source.g.dart';

@RestApi()
abstract class NotificationsRemoteDataSource {
  factory NotificationsRemoteDataSource(Dio dio) =
      _NotificationsRemoteDataSource;

  /// Newest first; `meta` has `{ total, page, limit, totalPages }`.
  @GET('/notifications')
  Future<ApiListEnvelopeModel> getNotifications(
    @Header('Authorization') String bearerToken,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// `data`: `{ count }`.
  @GET('/notifications/unread-count')
  Future<ApiEnvelopeModel> getUnreadCount(
    @Header('Authorization') String bearerToken,
  );

  /// `data`: the updated notification, with `readAt` set.
  @PATCH('/notifications/{id}/read')
  Future<ApiEnvelopeModel> markRead(
    @Header('Authorization') String bearerToken,
    @Path('id') String notificationId,
  );

  /// Saves this device's FCM token: `{ token, platform?, previousToken? }`.
  /// `previousToken` (after Firebase rotates the token) removes the old row.
  @POST('/users/me/device-token')
  Future<ApiEnvelopeModel> registerDeviceToken(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );
}
