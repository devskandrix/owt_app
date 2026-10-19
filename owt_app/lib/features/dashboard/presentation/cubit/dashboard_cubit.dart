import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../domain/usecases/get_home_clubs.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getHomeClubs, this._locationService)
    : super(const DashboardState()) {
    load();
  }

  final GetHomeClubs _getHomeClubs;
  final LocationService _locationService;

  /// Loads the dashboard's club lists via `GET /clubs/home`. Passes the
  /// device's location when it's already allowed so `nearYou` can be
  /// ordered by distance — this screen never prompts for permission (that
  /// happens in the Going Tonight flow); without it, the clubs still load
  /// with no latitude/longitude — see [LocationService].
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
      emit(
        state.copyWith(loadStatus: DashboardLoadStatus.loaded, clubs: clubs),
      );
    } on Failure catch (f) {
      emit(
        state.copyWith(
          loadStatus: DashboardLoadStatus.failure,
          errorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          loadStatus: DashboardLoadStatus.failure,
          errorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
