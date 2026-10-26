import '../../../../core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class GetUnreadNotificationCount implements UseCase<int, NoParams> {
  final NotificationsRepository repository;

  const GetUnreadNotificationCount(this.repository);

  @override
  Future<int> call(NoParams params) => repository.getUnreadCount();
}
