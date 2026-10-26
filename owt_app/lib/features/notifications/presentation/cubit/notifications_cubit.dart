import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_read.dart';
import 'unread_notifications_cubit.dart';

enum NotificationsStatus { loading, ready, failure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<AppNotification> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.loading,
    this.items = const [],
    this.page = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    hasMore,
    isLoadingMore,
    errorMessage,
  ];
}

/// The Notification screen: `GET /notifications` page by page (newest
/// first), and `PATCH /notifications/:id/read` when an unread one is
/// tapped. Keeps the bell badge ([UnreadNotificationsCubit]) in step.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._getNotifications, this._markRead, this._unread)
    : super(const NotificationsState());

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markRead;
  final UnreadNotificationsCubit _unread;

  static const pageSize = 20;

  /// Loads (or reloads) the first page.
  Future<void> load() async {
    // A refresh keeps showing the current list while it loads.
    if (state.status != NotificationsStatus.ready) {
      emit(const NotificationsState());
    }
    try {
      final result = await _getNotifications(
        const GetNotificationsParams(page: 1, limit: pageSize),
      );
      if (isClosed) return;
      emit(
        NotificationsState(
          status: NotificationsStatus.ready,
          items: result.items,
          page: result.page,
          hasMore: result.hasMore,
        ),
      );
      _unread.refresh();
    } on Failure catch (f) {
      _fail(f.message);
    } catch (_) {
      _fail(AppStrings.somethingWentWrong);
    }
  }

  /// Appends the next page; called near the end of the list.
  Future<void> loadMore() async {
    if (state.status != NotificationsStatus.ready ||
        !state.hasMore ||
        state.isLoadingMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final result = await _getNotifications(
        GetNotificationsParams(page: state.page + 1, limit: pageSize),
      );
      if (isClosed) return;
      // Skip any already shown, in case new ones shifted the pages.
      final seen = {for (final n in state.items) n.id};
      emit(
        state.copyWith(
          items: [
            ...state.items,
            ...result.items.where((n) => !seen.contains(n.id)),
          ],
          page: result.page,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } on Failure catch (f) {
      if (!isClosed) {
        emit(state.copyWith(isLoadingMore: false, errorMessage: f.message));
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorMessage: AppStrings.somethingWentWrong,
          ),
        );
      }
    }
  }

  /// Marks [id] read right away, then confirms with the server; puts it
  /// back to unread if that fails.
  Future<void> markRead(String id) async {
    final index = state.items.indexWhere((n) => n.id == id);
    if (index == -1 || state.items[index].isRead) return;
    final original = state.items[index];

    _replace(original.markedRead(DateTime.now()));
    _unread.decrement();
    try {
      _replace(await _markRead(id));
    } catch (_) {
      _replace(original);
      _unread.refresh();
    }
  }

  void _replace(AppNotification updated) {
    if (isClosed) return;
    final items = [
      for (final n in state.items)
        if (n.id == updated.id) _keepClub(updated, n) else n,
    ];
    emit(state.copyWith(items: items));
  }

  /// The PATCH response has no nested `club`, so keep the name we had.
  static AppNotification _keepClub(
    AppNotification updated,
    AppNotification old,
  ) {
    if (updated.clubName != null || old.clubName == null) return updated;
    return AppNotification(
      id: updated.id,
      type: updated.type,
      message: updated.message,
      createdAt: updated.createdAt,
      clubId: updated.clubId,
      clubName: old.clubName,
      readAt: updated.readAt,
    );
  }

  void _fail(String message) {
    if (isClosed) return;
    emit(
      state.copyWith(
        // Keep a loaded list on screen if only the refresh failed.
        status: state.status == NotificationsStatus.ready
            ? NotificationsStatus.ready
            : NotificationsStatus.failure,
        errorMessage: message,
      ),
    );
  }
}
