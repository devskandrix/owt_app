import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/social_auth_provider.dart';
import '../entities/social_auth_result.dart';
import '../repositories/auth_repository.dart';

class SocialSignIn implements UseCase<SocialAuthResult, SocialSignInParams> {
  final AuthRepository repository;

  const SocialSignIn(this.repository);

  @override
  Future<SocialAuthResult> call(SocialSignInParams params) {
    return repository.signInWithSocialProvider(
      provider: params.provider,
      idToken: params.idToken,
    );
  }
}

class SocialSignInParams extends Equatable {
  final SocialAuthProvider provider;
  final String idToken;

  const SocialSignInParams({required this.provider, required this.idToken});

  @override
  List<Object?> get props => [provider, idToken];
}
