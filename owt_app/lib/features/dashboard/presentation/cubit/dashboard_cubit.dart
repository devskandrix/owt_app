import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../notifications/presentation/cubit/unread_notifications_cubit.dart';
import '../../domain/usecases/get_home_clubs.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getHomeClubs, this._locationService, this._unread)
    : super(const DashboardState()) {
    load();
  }

  final GetHomeClubs _getHomeClubs;
  final LocationService _locationService;
  final UnreadNotificationsCubit _unread;

  /// Loads the dashboard's club lists via `GET /clubs/home`. Passes the
  /// device's location when it's allowed so `nearYou` can be ordered by
  /// distance; without it, the clubs still load with no latitude/longitude
  /// — see [LocationService]. Never prompts itself: the page asks via its
  /// explainer dialog and calls this again once permission is granted.
  Future<void> load() async {
    emit(state.copyWith(loadStatus: DashboardLoadStatus.loading));
    try {
      final position = await _locationService.getCurrentPosition();
      final clubs = await _getHomeClubs(
        GetHomeClubsParams(
          latitude: position?.latitude,
          longitude: position?.longitude,
        ),
      );
      // Home may have been left while the request was in flight.
      if (isClosed) return;
      final unreadCount = clubs.unreadNotificationCount;
      if (unreadCount != null) {
        _unread.setCount(unreadCount);
      } else {
        // Older server without the field: ask the notifications API instead.
        _unread.refresh();
      }
      emit(
        state.copyWith(loadStatus: DashboardLoadStatus.loaded, clubs: clubs),
      );
    } on Failure catch (f) {
      if (isClosed) return;
      emit(
        state.copyWith(
          loadStatus: DashboardLoadStatus.failure,
          errorMessage: f.message,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          loadStatus: DashboardLoadStatus.failure,
          errorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
