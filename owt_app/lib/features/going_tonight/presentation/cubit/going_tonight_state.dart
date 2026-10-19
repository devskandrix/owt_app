import 'package:equatable/equatable.dart';

enum GoingTonightStatus { verifying, verified, failure }

/// Why verification failed — each maps to its own message and, where it
/// helps, an "Open Settings" action.
enum GoingTonightFailure {
  locationServiceDisabled,
  permissionDenied,
  permissionDeniedForever,
  locationUnavailable,
  notNearVenue,
}

class GoingTonightState extends Equatable {
  final GoingTonightStatus status;

  final GoingTonightFailure? failure;

  /// When the badge stops being valid (the next 5:00 AM).
  final DateTime? validUntil;

  const GoingTonightState({
    this.status = GoingTonightStatus.verifying,
    this.failure,
    this.validUntil,
  });

  @override
  List<Object?> get props => [status, failure, validUntil];
}
