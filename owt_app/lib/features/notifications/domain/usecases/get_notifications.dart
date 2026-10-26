import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/notification_page.dart';
import '../repositories/notifications_repository.dart';

class GetNotifications
    implements UseCase<NotificationPage, GetNotificationsParams> {
  final NotificationsRepository repository;

  const GetNotifications(this.repository);

  @override
  Future<NotificationPage> call(GetNotificationsParams params) =>
      repository.getNotifications(page: params.page, limit: params.limit);
}

class GetNotificationsParams extends Equatable {
  final int page;
  final int limit;

  const GetNotificationsParams({required this.page, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}
