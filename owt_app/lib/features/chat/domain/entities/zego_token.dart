import 'package:equatable/equatable.dart';

/// A ZEGOCLOUD login token from `GET /zego/token`, used instead of the
/// AppSign in live (production) mode.
class ZegoToken extends Equatable {
  final String token;
  final DateTime expiresAt;

  const ZegoToken({required this.token, required this.expiresAt});

  /// True when it expires within [margin] (or already has).
  bool expiresWithin(Duration margin) =>
      DateTime.now().add(margin).isAfter(expiresAt);

  @override
  List<Object?> get props => [token, expiresAt];
}
