import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SendSignupOtp implements UseCase<void, SendSignupOtpParams> {
  final AuthRepository repository;

  const SendSignupOtp(this.repository);

  @override
  Future<void> call(SendSignupOtpParams params) {
    return repository.sendSignupOtp(phoneNumber: params.phoneNumber);
  }
}

class SendSignupOtpParams extends Equatable {
  final String phoneNumber;

  const SendSignupOtpParams(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}
