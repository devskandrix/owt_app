import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../auth/domain/entities/gender.dart';
import '../../../auth/domain/usecases/register_user.dart';
import 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit(this._registerUser) : super(const CreateAccountState());

  final RegisterUser _registerUser;

  void selectGender(Gender gender) => emit(state.copyWith(gender: gender));

  void setAgreedToTerms(bool agreed) =>
      emit(state.copyWith(agreedToTerms: agreed));

  Future<void> register({
    required String? fullName,
    required DateTime dateOfBirth,
  }) async {
    final gender = state.gender;
    if (gender == null) return;

    emit(state.copyWith(status: CreateAccountStatus.loading));
    try {
      await _registerUser(
        RegisterUserParams(
          fullName: fullName,
          dateOfBirth: dateOfBirth,
          gender: gender,
        ),
      );
      emit(state.copyWith(status: CreateAccountStatus.success));
    } on Failure catch (f) {
      emit(
        state.copyWith(
          status: CreateAccountStatus.failure,
          errorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CreateAccountStatus.failure,
          errorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
