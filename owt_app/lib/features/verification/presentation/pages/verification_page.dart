import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/auth_logo_badge.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../../../phone_number/presentation/cubit/send_otp_cubit.dart';
import '../../../phone_number/presentation/cubit/send_otp_state.dart';
import '../cubit/verify_otp_cubit.dart';
import '../cubit/verify_otp_state.dart';
import '../widgets/otp_code_row.dart';
import '../widgets/resend_code_prompt.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<VerifyOtpCubit>()),
        BlocProvider(create: (_) => sl<SendOtpCubit>()),
      ],
      child: _VerificationView(phoneNumber: phoneNumber),
    );
  }
}

class _VerificationView extends StatefulWidget {
  const _VerificationView({required this.phoneNumber});

  final String phoneNumber;

  @override
  State<_VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<_VerificationView> {
  static const _otpLength = 4;
  String _otp = '';

  void _continue() {
    if (_otp.length != _otpLength) return;
    context.read<VerifyOtpCubit>().verify(widget.phoneNumber, _otp);
  }

  void _resend() {
    context.read<SendOtpCubit>().send(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyOtpCubit, VerifyOtpState>(
          listener: (context, state) {
            if (state.status == VerifyOtpStatus.success) {
              context.pushNamed(AppRoute.createAccount.name);
            } else if (state.status == VerifyOtpStatus.failure) {
              TopNotice.showError(context, state.errorMessage!);
            }
          },
        ),
        BlocListener<SendOtpCubit, SendOtpState>(
          listener: (context, state) {
            if (state.status == SendOtpStatus.success) {
              TopNotice.showSuccess(context, AppStrings.codeResent);
            } else if (state.status == SendOtpStatus.failure) {
              TopNotice.showError(context, state.errorMessage!);
            }
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        const AuthLogoBadge(),
                        const SizedBox(height: 40),
                        Assets.images.mobileIllustration.image(
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          AppStrings.verifyYourNumberHeadline,
                          style: AppTextStyles.authHeadline.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.verifyYourNumberSubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.authSubtitle.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 40),
                        OtpCodeRow(
                          onChanged: (value) => setState(() => _otp = value),
                        ),
                      ],
                    ),
                  ),
                ),
                ResendCodePrompt(onResend: _resend),
                const SizedBox(height: 20),
                BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                  builder: (context, state) {
                    return GradientButton(
                      label: AppStrings.continueLabel,
                      onPressed: _continue,
                      isLoading: state.status == VerifyOtpStatus.loading,
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
