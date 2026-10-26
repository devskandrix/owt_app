import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_page.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/app_notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  const NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<NotificationPage> getNotifications({
    required int page,
    int limit = 20,
  }) async {
    const fallback = 'Failed to load notifications.';
    final token = await _bearerToken();
    try {
      final envelope = await remoteDataSource.getNotifications(
        token,
        page,
        limit,
      );
      final data = envelope.data;
      if (!envelope.success || data == null) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final meta = envelope.meta ?? const {};
      return NotificationPage(
        items: [
          for (final item in data.whereType<Map<String, dynamic>>())
            ?AppNotificationModel.fromJson(item),
        ],
        page: _int(meta['page']) ?? page,
        totalPages: _int(meta['totalPages']) ?? page,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    const fallback = 'Failed to load notifications.';
    final token = await _bearerToken();
    try {
      final envelope = await remoteDataSource.getUnreadCount(token);
      final data = envelope.data;
      if (!envelope.success || data == null) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return _int(data['count']) ?? 0;
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<AppNotification> markRead(String notificationId) async {
    const fallback = 'Failed to update notification.';
    final token = await _bearerToken();
    try {
      final envelope = await remoteDataSource.markRead(token, notificationId);
      final data = envelope.data;
      final notification = data == null
          ? null
          : AppNotificationModel.fromJson(data);
      if (!envelope.success || notification == null) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return notification;
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    String? platform,
    String? previousToken,
  }) async {
    const fallback = 'Failed to register this device for notifications.';
    final bearer = await _bearerToken();
    try {
      final envelope = await remoteDataSource.registerDeviceToken(bearer, {
        'token': token,
        'platform': ?platform,
        'previousToken': ?previousToken,
      });
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  static int? _int(dynamic value) => value is num ? value.toInt() : null;

  Future<String> _bearerToken() async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    return 'Bearer $accessToken';
  }

  Failure _mapDioException(DioException e, {required String fallbackMessage}) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Could not reach the server. Check your connection and try again.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        final serverMessage = data is Map<String, dynamic>
            ? data['message'] as String?
            : null;
        return ServerFailure(
          serverMessage ?? '$fallbackMessage (${statusCode ?? 'unknown'}).',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      // ignore: no_default_cases
      default:
        return UnexpectedFailure(e.message ?? fallbackMessage);
    }
  }
}
