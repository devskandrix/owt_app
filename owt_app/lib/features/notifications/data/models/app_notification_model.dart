import '../../domain/entities/app_notification.dart';

/// Parses one notification from `GET /notifications` or
/// `PATCH /notifications/:id/read` (which has no nested `club`).
abstract final class AppNotificationModel {
  /// Null when `id` is missing, so one bad row doesn't break the list.
  static AppNotification? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String) return null;
    final club = json['club'];
    return AppNotification(
      id: id,
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      clubId: json['clubId'] as String?,
      clubName: club is Map<String, dynamic> ? club['name'] as String? : null,
      readAt: _date(json['readAt']),
      createdAt: _date(json['createdAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _date(dynamic value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}
