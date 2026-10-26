import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../cubit/interests_cubit.dart';
import '../cubit/interests_state.dart';
import 'interest_category_section.dart';

/// Bottom sheet for editing interests from Profile, using the onboarding
/// Interests UI: loads `GET /interests`, starts with [selectedIds]
/// selected, and saves with `PUT /users/me/interests`.
class EditInterestsSheet extends StatelessWidget {
  const EditInterestsSheet({super.key});

  /// Returns true when the interests were saved.
  static Future<bool> show(
    BuildContext context, {
    required Set<String> selectedIds,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<InterestsCubit>()..preselect(selectedIds),
        child: const EditInterestsSheet(),
      ),
    );
    return saved ?? false;
  }

  void _onToggle(BuildContext context, String interestId) {
    final added = context.read<InterestsCubit>().toggle(interestId);
    if (!added) TopNotice.showError(context, AppStrings.maxInterestsReached);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocListener<InterestsCubit, InterestsState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == InterestsSubmitStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.submitStatus == InterestsSubmitStatus.failure) {
          TopNotice.showError(context, state.submitErrorMessage!);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.inputBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.editInterestsHeadline,
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
                const SizedBox(height: 20),
                Flexible(
                  child: BlocBuilder<InterestsCubit, InterestsState>(
                    builder: (context, state) => switch (state.loadStatus) {
                      InterestsLoadStatus.loading => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      InterestsLoadStatus.failure => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: TextButton(
                            onPressed: context.read<InterestsCubit>().load,
                            child: Text(
                              state.loadErrorMessage ??
                                  AppStrings.somethingWentWrong,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.authSubtitle.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InterestsLoadStatus.loaded => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (
                              var i = 0;
                              i < state.categories.length;
                              i++
                            ) ...[
                              if (i != 0) const SizedBox(height: 18),
                              InterestCategorySection(
                                title: state.categories[i].name,
                                interests: state.categories[i].interests,
                                selectedIds: state.selectedIds,
                                onToggle: (id) => _onToggle(context, id),
                              ),
                            ],
                          ],
                        ),
                      ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: BlocBuilder<InterestsCubit, InterestsState>(
                    builder: (context, state) => GradientButton(
                      label: AppStrings.saveLabel,
                      enabled:
                          state.loadStatus == InterestsLoadStatus.loaded &&
                          state.selectedIds.length >=
                              InterestsCubit.minSelected,
                      isLoading:
                          state.submitStatus == InterestsSubmitStatus.loading,
                      onPressed: context.read<InterestsCubit>().submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
