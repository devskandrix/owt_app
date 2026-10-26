import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/going_tonight_badge.dart';
import '../repositories/matchmaking_repository.dart';

class CheckInGoingTonight
    implements UseCase<GoingTonightBadge, CheckInGoingTonightParams> {
  final MatchmakingRepository repository;

  const CheckInGoingTonight(this.repository);

  @override
  Future<GoingTonightBadge> call(CheckInGoingTonightParams params) =>
      repository.checkInGoingTonight(
        clubId: params.clubId,
        latitude: params.latitude,
        longitude: params.longitude,
      );
}

class CheckInGoingTonightParams extends Equatable {
  /// The club being checked into; null lets the server pick from location.
  final String? clubId;
  final double latitude;
  final double longitude;

  const CheckInGoingTonightParams({
    this.clubId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [clubId, latitude, longitude];
}
