import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/gender.dart';

enum CreateAccountStatus { idle, loading, success, failure }

class CreateAccountState extends Equatable {
  final Gender? gender;
  final bool agreedToTerms;
  final CreateAccountStatus status;
  final String? errorMessage;

  const CreateAccountState({
    this.gender,
    this.agreedToTerms = true,
    this.status = CreateAccountStatus.idle,
    this.errorMessage,
  });

  CreateAccountState copyWith({
    Gender? gender,
    bool? agreedToTerms,
    CreateAccountStatus? status,
    String? errorMessage,
  }) {
    return CreateAccountState(
      gender: gender ?? this.gender,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [gender, agreedToTerms, status, errorMessage];
}
