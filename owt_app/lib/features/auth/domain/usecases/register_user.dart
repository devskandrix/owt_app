import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../entities/gender.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<AuthSession, RegisterUserParams> {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  @override
  Future<AuthSession> call(RegisterUserParams params) {
    return repository.register(
      fullName: params.fullName,
      dateOfBirth: params.dateOfBirth,
      gender: params.gender,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String? fullName;
  final DateTime dateOfBirth;
  final Gender gender;

  const RegisterUserParams({
    this.fullName,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  List<Object?> get props => [fullName, dateOfBirth, gender];
}
