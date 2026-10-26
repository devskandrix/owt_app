import '../../../../core/usecase/usecase.dart';
import '../entities/zego_token.dart';
import '../repositories/zego_token_repository.dart';

class GetZegoToken implements UseCase<ZegoToken, NoParams> {
  final ZegoTokenRepository repository;

  const GetZegoToken(this.repository);

  @override
  Future<ZegoToken> call(NoParams params) => repository.getToken();
}
