import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/services/location_service.dart';
import 'going_tonight_state.dart';

/// Verifies the user is physically at a venue before activating their
/// Going Tonight badge: asks for location permission, reads a live
/// position, and — when the venue's coordinates are known — checks the
/// user is within [maxDistanceMeters] of it.
///
/// TODO: once the backend exposes a Going Tonight endpoint, send the
/// position there instead and take `validUntil` from its response.
class GoingTonightCubit extends Cubit<GoingTonightState> {
  GoingTonightCubit(
    this._locationService, {
    this.venueLatitude,
    this.venueLongitude,
  }) : super(const GoingTonightState());

  final LocationService _locationService;
  final double? venueLatitude;
  final double? venueLongitude;

  static const double maxDistanceMeters = 300;

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
    await _waitAtLeast(started);
    if (isClosed) return;
    if (position == null) {
      _fail(GoingTonightFailure.locationUnavailable);
      return;
    }

    final lat = venueLatitude;
    final lng = venueLongitude;
    if (lat != null && lng != null) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lat,
        lng,
      );
      if (distance > maxDistanceMeters) {
        _fail(GoingTonightFailure.notNearVenue);
        return;
      }
    }

    emit(
      GoingTonightState(
        status: GoingTonightStatus.verified,
        validUntil: _nextFiveAm(DateTime.now()),
      ),
    );
  }

  Future<void> openLocationSettings() async {
    final access = _lastAccess;
    if (access != null) await _locationService.openSettingsFor(access);
  }

  void _fail(GoingTonightFailure failure) {
    if (isClosed) return;
    emit(
      GoingTonightState(
        status: GoingTonightStatus.failure,
        failure: failure,
      ),
    );
  }

  Future<void> _waitAtLeast(DateTime started) async {
    final remaining = _minVerifyDuration - DateTime.now().difference(started);
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);
  }

  /// A night out ends at 5:00 AM — today's if it's still before then,
  /// otherwise tomorrow's.
  static DateTime _nextFiveAm(DateTime now) {
    final today = DateTime(now.year, now.month, now.day, 5);
    return now.isBefore(today) ? today : today.add(const Duration(days: 1));
  }
}
