import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/onboarding_progress_bar.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/create_account_cubit.dart';
import '../cubit/create_account_state.dart';
import '../widgets/gender_selector.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/terms_checkbox_row.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateAccountCubit>(),
      child: const _CreateAccountView(),
    );
  }
}

class _CreateAccountView extends StatefulWidget {
  const _CreateAccountView();

  @override
  State<_CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<_CreateAccountView> {
  final _fullNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    // Only 18+ users may use the app, so the picker can't select a more
    // recent date of birth than exactly 18 years ago.
    final maxDateOfBirth = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: maxDateOfBirth,
      firstDate: DateTime(now.year - 100),
      lastDate: maxDateOfBirth,
    );
    if (picked != null) {
      _dateOfBirth = picked;
      _dateOfBirthController.text =
          '${picked.day.toString().padLeft(2, '0')} / '
          '${picked.month.toString().padLeft(2, '0')} / '
          '${picked.year}';
    }
  }

  void _continue() {
    final dateOfBirth = _dateOfBirth;
    if (dateOfBirth == null ||
        context.read<CreateAccountCubit>().state.gender == null) {
      TopNotice.showError(context, AppStrings.missingRequiredFields);
      return;
    }
    final fullName = _fullNameController.text.trim();
    context.read<CreateAccountCubit>().register(
      fullName: fullName.isEmpty ? null : fullName,
      dateOfBirth: dateOfBirth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocListener<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state.status == CreateAccountStatus.success) {
          context.pushNamed(AppRoute.interests.name);
        } else if (state.status == CreateAccountStatus.failure) {
          TopNotice.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20)
                .copyWith(top: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.createAccountHeadline,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onboardingHeadline.copyWith(
                    color: colors.strongText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.createAccountSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.onboardingSubtitle.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 32),
                const OnboardingProgressBar(currentStep: 1, totalSteps: 3),
                const SizedBox(height: 43),
                LabeledTextField(
                  label: AppStrings.fullNameLabel,
                  hintText: AppStrings.fullNamePlaceholder,
                  iconAsset: Assets.icons.user,
                  controller: _fullNameController,
                ),
                const SizedBox(height: 24),
                LabeledTextField(
                  label: AppStrings.dateOfBirthLabel,
                  hintText: AppStrings.dateOfBirthPlaceholder,
                  iconAsset: Assets.icons.calendar,
                  controller: _dateOfBirthController,
                  readOnly: true,
                  onTap: _pickDateOfBirth,
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.genderLabel,
                  style: AppTextStyles.fieldLabel.copyWith(
                    color: colors.strongText,
                  ),
                ),
                const SizedBox(height: 6),
                BlocBuilder<CreateAccountCubit, CreateAccountState>(
                  builder: (context, state) {
                    return GenderSelector(
                      selected: state.gender,
                      onChanged: context
                          .read<CreateAccountCubit>()
                          .selectGender,
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<CreateAccountCubit, CreateAccountState>(
                  builder: (context, state) {
                    return TermsCheckboxRow(
                      checked: state.agreedToTerms,
                      onChanged: context
                          .read<CreateAccountCubit>()
                          .setAgreedToTerms,
                      onTermsOfUse: () {},
                      onPrivacyPolicy: () {},
                    );
                  },
                ),
                const SizedBox(height: 40),
                BlocBuilder<CreateAccountCubit, CreateAccountState>(
                  builder: (context, state) {
                    return GradientButton(
                      label: AppStrings.continueLabel,
                      onPressed: _continue,
                      isLoading: state.status == CreateAccountStatus.loading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
