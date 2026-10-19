import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../auth/domain/usecases/send_signup_otp.dart';
import 'send_otp_state.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  SendOtpCubit(this._sendSignupOtp) : super(const SendOtpState());

  final SendSignupOtp _sendSignupOtp;

  Future<void> send(String phoneNumber) async {
    emit(state.copyWith(status: SendOtpStatus.loading));
    try {
      await _sendSignupOtp(SendSignupOtpParams(phoneNumber));
      emit(state.copyWith(status: SendOtpStatus.success));
    } on Failure catch (f) {
      emit(
        state.copyWith(status: SendOtpStatus.failure, errorMessage: f.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SendOtpStatus.failure,
          errorMessage: AppStrings.somethingWentWrong,
        ),
      );
    }
  }
}
