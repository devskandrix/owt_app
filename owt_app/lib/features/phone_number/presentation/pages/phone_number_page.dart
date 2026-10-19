import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/country.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/auth_logo_badge.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/selected_country_cubit.dart';
import '../cubit/send_otp_cubit.dart';
import '../cubit/send_otp_state.dart';
import '../widgets/country_code_picker_sheet.dart';
import '../widgets/phone_number_field.dart';

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SelectedCountryCubit()),
        BlocProvider(create: (_) => sl<SendOtpCubit>()),
      ],
      child: const _PhoneNumberView(),
    );
  }
}

class _PhoneNumberView extends StatefulWidget {
  const _PhoneNumberView();

  @override
  State<_PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<_PhoneNumberView> {
  final _phoneController = TextEditingController();
  String? _submittedPhoneNumber;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final picked = await CountryCodePickerSheet.show(context);
    if (picked != null && mounted) {
      context.read<SelectedCountryCubit>().select(picked);
    }
  }

  void _continue() {
    final dialCode = context.read<SelectedCountryCubit>().state.dialCode;
    final localNumber = _phoneController.text.trim();
    if (localNumber.isEmpty) return;
    _submittedPhoneNumber = '$dialCode$localNumber';
    context.read<SendOtpCubit>().send(_submittedPhoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocConsumer<SendOtpCubit, SendOtpState>(
      listener: (context, state) {
        if (state.status == SendOtpStatus.success) {
          context.pushNamed(
            AppRoute.verification.name,
            extra: _submittedPhoneNumber,
          );
        } else if (state.status == SendOtpStatus.failure) {
          TopNotice.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          const AuthLogoBadge(),
                          const SizedBox(height: 40),
                          Assets.images.phoneIllustration.image(
                            width: 150,
                            height: 150,
                          ),
                          Text(
                            AppStrings.enterYourNumberHeadline,
                            style: AppTextStyles.authHeadline.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.enterYourNumberSubtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.authSubtitle.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 28),
                          BlocBuilder<SelectedCountryCubit, Country>(
                            builder: (context, country) {
                              return PhoneNumberField(
                                controller: _phoneController,
                                country: country,
                                onCountryTap: _pickCountry,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  GradientButton(
                    label: AppStrings.continueLabel,
                    onPressed: _continue,
                    isLoading: state.status == SendOtpStatus.loading,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
