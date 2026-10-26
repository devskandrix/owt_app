import 'package:equatable/equatable.dart';

import 'app_notification.dart';

/// One page of `GET /notifications`, newest first.
class NotificationPage extends Equatable {
  final List<AppNotification> items;
  final int page;
  final int totalPages;

  const NotificationPage({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [items, page, totalPages];
}
