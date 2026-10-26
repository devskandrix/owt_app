import 'package:equatable/equatable.dart';

enum GoingTonightStatus { verifying, verified, failure }

/// Why verification failed — each maps to its own message and, where it
/// helps, an "Open Settings" action.
enum GoingTonightFailure {
  locationServiceDisabled,
  permissionDenied,
  permissionDeniedForever,
  locationUnavailable,

  /// The check-in request failed (e.g. not near any club); see
  /// [GoingTonightState.errorMessage].
  checkInFailed,
}

class GoingTonightState extends Equatable {
  final GoingTonightStatus status;
  final GoingTonightFailure? failure;

  /// The server's reason when [failure] is [GoingTonightFailure.checkInFailed].
  final String? errorMessage;

  /// The club the server checked the user in at.
  final String? clubId;
  final String? clubName;

  /// When the badge stops being valid.
  final DateTime? validUntil;

  const GoingTonightState({
    this.status = GoingTonightStatus.verifying,
    this.failure,
    this.errorMessage,
    this.clubId,
    this.clubName,
    this.validUntil,
  });

  @override
  List<Object?> get props => [
    status,
    failure,
    errorMessage,
    clubId,
    clubName,
    validUntil,
  ];
}
