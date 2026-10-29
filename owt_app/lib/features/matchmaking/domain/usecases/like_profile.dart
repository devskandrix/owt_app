import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/like_outcome.dart';
import '../repositories/matchmaking_repository.dart';

/// Swipe right.
class LikeProfile implements UseCase<LikeOutcome, LikeProfileParams> {
  final MatchmakingRepository repository;

  const LikeProfile(this.repository);

  @override
  Future<LikeOutcome> call(LikeProfileParams params) =>
      repository.like(receiverId: params.receiverId, clubId: params.clubId);
}

class LikeProfileParams extends Equatable {
  final String receiverId;
  final String clubId;

  const LikeProfileParams({required this.receiverId, required this.clubId});

  @override
  List<Object?> get props => [receiverId, clubId];
}
