import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifySignupOtp implements UseCase<void, VerifySignupOtpParams> {
  final AuthRepository repository;

  const VerifySignupOtp(this.repository);

  @override
  Future<void> call(VerifySignupOtpParams params) {
    return repository.verifySignupOtp(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
    );
  }
}

class VerifySignupOtpParams extends Equatable {
  final String phoneNumber;
  final String otp;

  const VerifySignupOtpParams(this.phoneNumber, this.otp);

  @override
  List<Object?> get props => [phoneNumber, otp];
}
