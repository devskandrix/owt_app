import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_unread_notification_count.dart';

/// App-wide unread notification count for the bell badge
/// (`GET /notifications/unread-count`). Refreshed whenever a bell appears
/// and after the Notification screen marks items read; set directly from
/// `GET /clubs/home` on Home; reset on sign-out.
class UnreadNotificationsCubit extends Cubit<int> {
  UnreadNotificationsCubit(this._getUnreadCount) : super(0);

  final GetUnreadNotificationCount _getUnreadCount;

  /// The request in flight, so several bells share one.
  Future<void>? _loading;

  Future<void> refresh() => _loading ??= _refresh().whenComplete(() {
    _loading = null;
  });

  Future<void> _refresh() async {
    try {
      final count = await _getUnreadCount(const NoParams());
      if (!isClosed) emit(count);
    } catch (_) {
      // The badge is a hint: keep the last count if this fails.
    }
  }

  /// A count that arrived with another response (e.g. `GET /clubs/home`).
  void setCount(int count) {
    if (!isClosed) emit(count < 0 ? 0 : count);
  }

  /// One notification was just marked read.
  void decrement() {
    if (!isClosed && state > 0) emit(state - 1);
  }

  void reset() {
    if (!isClosed) emit(0);
  }
}
