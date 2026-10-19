import 'package:geolocator/geolocator.dart';

/// Outcome of [LocationService.requestAccess], so callers that *require*
/// a location (e.g. Going Tonight verification) can tell the user why it
/// isn't available.
enum LocationAccess { granted, serviceDisabled, denied, deniedForever }

/// Device location. [getCurrentPosition] is best-effort (used to pass
/// latitude/longitude to `GET /clubs/home` for `nearYou` ordering): it
/// never prompts or throws, and a missing permission, disabled location
/// services, or a timeout all surface as a null position.
class LocationService {
  const LocationService();

  /// Whether location is already usable, without prompting — lets callers
  /// skip an in-app "Allow location?" explainer when it isn't needed.
  Future<bool> hasAccess() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (_) {
      return false;
    }
  }

  /// Whether [requestAccess] would show the OS permission prompt — i.e.
  /// location services are on and the user hasn't decided yet (or, on
  /// Android, can still be asked again).
  Future<bool> canPromptForPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return false;
      return await Geolocator.checkPermission() == LocationPermission.denied;
    } catch (_) {
      return false;
    }
  }

  /// Checks location services and permission, prompting for permission if
  /// it hasn't been decided yet. Never throws.
  Future<LocationAccess> requestAccess() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationAccess.serviceDisabled;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return switch (permission) {
        LocationPermission.deniedForever => LocationAccess.deniedForever,
        LocationPermission.denied ||
        LocationPermission.unableToDetermine => LocationAccess.denied,
        _ => LocationAccess.granted,
      };
    } catch (_) {
      return LocationAccess.denied;
    }
  }

  /// Opens the OS settings screen relevant to [access] so the user can turn
  /// location back on.
  Future<void> openSettingsFor(LocationAccess access) async {
    if (access == LocationAccess.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }

  /// Reads the current position only if location is already allowed —
  /// never shows the OS permission prompt. Asking is left to
  /// [requestAccess], which the Going Tonight flow calls after its own
  /// explainer dialog.
  Future<Position?> getCurrentPosition() async {
    try {
      if (!await hasAccess()) return null;

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (_) {
        // A fresh fix can be slow indoors; fall back to the last known one,
        // but only if it's recent — an old fix could be somewhere else
        // entirely, which matters for Going Tonight verification.
        final last = await Geolocator.getLastKnownPosition();
        if (last == null) return null;
        final age = DateTime.now().difference(last.timestamp);
        return age <= _maxLastKnownAge ? last : null;
      }
    } catch (_) {
      return null;
    }
  }

  static const Duration _maxLastKnownAge = Duration(minutes: 5);
}
