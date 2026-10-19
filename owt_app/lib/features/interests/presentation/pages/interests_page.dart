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
import '../cubit/interests_cubit.dart';
import '../cubit/interests_state.dart';
import '../widgets/interest_category_section.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InterestsCubit>(),
      child: const _InterestsView(),
    );
  }
}

class _InterestsView extends StatelessWidget {
  const _InterestsView();

  void _onToggle(BuildContext context, String interestId) {
    final added = context.read<InterestsCubit>().toggle(interestId);
    if (!added) {
      TopNotice.showError(context, AppStrings.maxInterestsReached);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocListener<InterestsCubit, InterestsState>(
      listener: (context, state) {
        if (state.submitStatus == InterestsSubmitStatus.success) {
          context.pushNamed(AppRoute.addPhotos.name);
        } else if (state.submitStatus == InterestsSubmitStatus.failure) {
          TopNotice.showError(context, state.submitErrorMessage!);
        } else if (state.loadStatus == InterestsLoadStatus.failure) {
          TopNotice.showError(context, state.loadErrorMessage!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
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
              ),
              Expanded(
                child: BlocBuilder<InterestsCubit, InterestsState>(
                  builder: (context, state) {
                    if (state.loadStatus == InterestsLoadStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.loadStatus == InterestsLoadStatus.failure) {
                      return Center(
                        child: TextButton(
                          onPressed: () =>
                              context.read<InterestsCubit>().load(),
                          child: Text(
                            state.loadErrorMessage ??
                                AppStrings.somethingWentWrong,
                            style: AppTextStyles.authSubtitle.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.interestsHeadline,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.onboardingHeadline.copyWith(
                              color: colors.strongText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.interestsSubtitle,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.onboardingSubtitle.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const OnboardingProgressBar(
                            currentStep: 2,
                            totalSteps: 3,
                          ),
                          const SizedBox(height: 28),
                          for (var i = 0; i < state.categories.length; i++) ...[
                            if (i != 0) const SizedBox(height: 18),
                            InterestCategorySection(
                              title: state.categories[i].name,
                              interests: state.categories[i].interests,
                              selectedIds: state.selectedIds,
                              onToggle: (id) => _onToggle(context, id),
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: BlocBuilder<InterestsCubit, InterestsState>(
                  builder: (context, state) {
                    final canContinue =
                        state.selectedIds.length >= InterestsCubit.minSelected;
                    return GradientButton(
                      label: AppStrings.continueLabel,
                      enabled: canContinue,
                      isLoading:
                          state.submitStatus == InterestsSubmitStatus.loading,
                      onPressed: () => context.read<InterestsCubit>().submit(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
