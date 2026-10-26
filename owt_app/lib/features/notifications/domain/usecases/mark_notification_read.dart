import '../../../../core/usecase/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notifications_repository.dart';

class MarkNotificationRead implements UseCase<AppNotification, String> {
  final NotificationsRepository repository;

  const MarkNotificationRead(this.repository);

  @override
  Future<AppNotification> call(String notificationId) =>
      repository.markRead(notificationId);
}
