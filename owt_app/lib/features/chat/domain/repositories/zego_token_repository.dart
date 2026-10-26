import '../entities/zego_token.dart';

abstract class ZegoTokenRepository {
  /// `GET /zego/token`: a ZEGOCLOUD token for the signed-in user.
  Future<ZegoToken> getToken();
}
