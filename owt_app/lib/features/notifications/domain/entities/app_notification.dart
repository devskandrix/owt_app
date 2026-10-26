import 'package:equatable/equatable.dart';

/// One item from `GET /notifications`.
class AppNotification extends Equatable {
  final String id;

  /// e.g. `QUEUE_REMOVED_INACTIVITY`.
  final String type;
  final String message;
  final String? clubId;
  final String? clubName;

  /// Null while unread.
  final DateTime? readAt;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    this.clubId,
    this.clubName,
    this.readAt,
  });

  bool get isRead => readAt != null;

  AppNotification markedRead(DateTime at) => AppNotification(
    id: id,
    type: type,
    message: message,
    createdAt: createdAt,
    clubId: clubId,
    clubName: clubName,
    readAt: readAt ?? at,
  );

  @override
  List<Object?> get props => [
    id,
    type,
    message,
    clubId,
    clubName,
    readAt,
    createdAt,
  ];
}
