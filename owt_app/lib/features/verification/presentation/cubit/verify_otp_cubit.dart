import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../auth/domain/usecases/verify_signup_otp.dart';
import 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit(this._verifySignupOtp) : super(const VerifyOtpState());

  final VerifySignupOtp _verifySignupOtp;

  Future<void> verify(String phoneNumber, String otp) async {
    emit(state.copyWith(status: VerifyOtpStatus.loading));
    try {
      await _verifySignupOtp(VerifySignupOtpParams(phoneNumber, otp));
      emit(state.copyWith(status: VerifyOtpStatus.success));
    } on Failure catch (f) {
      emit(
        state.copyWith(
          status: VerifyOtpStatus.failure,
          errorMessage: f.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VerifyOtpStatus.failure,
          errorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
