import '../entities/app_notification.dart';
import '../entities/notification_page.dart';

abstract class NotificationsRepository {
  /// `GET /notifications?page=&limit=`, newest first.
  Future<NotificationPage> getNotifications({required int page, int limit});

  /// `GET /notifications/unread-count`.
  Future<int> getUnreadCount();

  /// `PATCH /notifications/:id/read`. Returns the updated notification.
  Future<AppNotification> markRead(String notificationId);

  /// `POST /users/me/device-token`. [platform] is `ANDROID`, `IOS` or
  /// `WEB`; pass [previousToken] only when Firebase rotated the token.
  Future<void> registerDeviceToken({
    required String token,
    String? platform,
    String? previousToken,
  });
}
