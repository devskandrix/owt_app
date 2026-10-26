import '../../../../core/usecase/usecase.dart';
import '../repositories/matchmaking_repository.dart';
import 'like_profile.dart';

/// Swipe left (`POST /matchmaking/pass`). Same `{ receiverId, clubId }`
/// as [LikeProfile].
class PassProfile implements UseCase<void, LikeProfileParams> {
  final MatchmakingRepository repository;

  const PassProfile(this.repository);

  @override
  Future<void> call(LikeProfileParams params) =>
      repository.pass(receiverId: params.receiverId, clubId: params.clubId);
}
