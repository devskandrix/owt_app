import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/location_service.dart';
import '../../../matchmaking/domain/usecases/check_in_going_tonight.dart';
import 'going_tonight_state.dart';

/// Activates the user's Going Tonight badge: asks for location permission,
/// reads a live position, and checks in with it via
/// `POST /matchmaking/going-tonight` — the server decides which club the
/// user is at and when the badge expires.
class GoingTonightCubit extends Cubit<GoingTonightState> {
  GoingTonightCubit(this._locationService, this._checkIn, {this.clubId})
    : super(const GoingTonightState());

  final LocationService _locationService;
  final CheckInGoingTonight _checkIn;

  /// The club the user is getting the badge for, sent with the check-in.
  final String? clubId;

  /// Keeps the "Verifying…" step on screen long enough to read, matching
  /// the "This usually takes 3-5 second" copy.
  static const Duration _minVerifyDuration = Duration(seconds: 3);

  LocationAccess? _lastAccess;

  Future<void> verify() async {
    emit(const GoingTonightState());
    final started = DateTime.now();

    final access = await _locationService.requestAccess();
    _lastAccess = access;
    if (access != LocationAccess.granted) {
      _fail(switch (access) {
        LocationAccess.serviceDisabled =>
          GoingTonightFailure.locationServiceDisabled,
        LocationAccess.deniedForever =>
          GoingTonightFailure.permissionDeniedForever,
        _ => GoingTonightFailure.permissionDenied,
      });
      return;
    }

    final position = await _locationService.getCurrentPosition();
    if (position == null) {
      await _waitAtLeast(started);
      _fail(GoingTonightFailure.locationUnavailable);
      return;
    }

    try {
      final badge = await _checkIn(
        CheckInGoingTonightParams(
          clubId: clubId,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      await _waitAtLeast(started);
      if (isClosed) return;
      emit(
        GoingTonightState(
          status: GoingTonightStatus.verified,
          clubId: badge.clubId,
          clubName: badge.clubName,
          validUntil: badge.expiresAt?.toLocal(),
        ),
      );
    } on Failure catch (f) {
      await _waitAtLeast(started);
      _fail(GoingTonightFailure.checkInFailed, message: f.message);
    } catch (_) {
      await _waitAtLeast(started);
      _fail(GoingTonightFailure.checkInFailed);
    }
  }

  Future<void> openLocationSettings() async {
    final access = _lastAccess;
    if (access != null) await _locationService.openSettingsFor(access);
  }

  void _fail(GoingTonightFailure failure, {String? message}) {
    if (isClosed) return;
    emit(
      GoingTonightState(
        status: GoingTonightStatus.failure,
        failure: failure,
        errorMessage: message,
      ),
    );
  }

  Future<void> _waitAtLeast(DateTime started) async {
    final remaining = _minVerifyDuration - DateTime.now().difference(started);
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);
  }
}
