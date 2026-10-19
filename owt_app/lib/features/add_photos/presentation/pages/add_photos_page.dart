import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/onboarding_progress_bar.dart';
import '../../../../core/widgets/top_notice.dart';
import '../cubit/add_photos_cubit.dart';
import '../cubit/add_photos_state.dart';
import '../widgets/feature_blurb_row.dart';
import '../widgets/photo_slot.dart';
import '../widgets/photo_source_sheet.dart';
import '../widgets/photo_tips_box.dart';

class AddPhotosPage extends StatelessWidget {
  const AddPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddPhotosCubit>(),
      child: const _AddPhotosView(),
    );
  }
}

class _AddPhotosView extends StatelessWidget {
  const _AddPhotosView();

  static final _picker = ImagePicker();

  Future<void> _addPhoto(BuildContext context) async {
    final source = await PhotoSourceSheet.show(context);
    if (source == null || !context.mounted) return;

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !context.mounted) return;

    final bytes = await picked.readAsBytes();
    if (!context.mounted) return;
    context.read<AddPhotosCubit>().upload(bytes, picked.name);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return BlocListener<AddPhotosCubit, AddPhotosState>(
      listener: (context, state) {
        if (state.actionErrorMessage != null) {
          TopNotice.showError(context, state.actionErrorMessage!);
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.addPhotosHeadline,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.onboardingHeadline.copyWith(
                          color: colors.strongText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.addPhotosSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.onboardingSubtitle.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const OnboardingProgressBar(
                        currentStep: 3,
                        totalSteps: 3,
                      ),
                      const SizedBox(height: 34),
                      BlocBuilder<AddPhotosCubit, AddPhotosState>(
                        builder: (context, state) {
                          final slots = List<Widget>.generate(
                            AddPhotosCubit.maxPhotos,
                            (index) {
                              if (index < state.photos.length) {
                                final photo = state.photos[index];
                                return PhotoSlot(
                                  imageUrl: photo.imageUrl,
                                  isDeleting: state.deletingPhotoIds.contains(
                                    photo.id,
                                  ),
                                  onRemove: () => context
                                      .read<AddPhotosCubit>()
                                      .remove(photo.id),
                                );
                              }
                              if (index == state.photos.length &&
                                  state.isUploading) {
                                return const PhotoSlot(isUploading: true);
                              }
                              return PhotoSlot(onTap: () => _addPhoto(context));
                            },
                          );

                          return Column(
                            children: [
                              for (var row = 0; row < 2; row++) ...[
                                if (row != 0) const SizedBox(height: 12),
                                Row(
                                  children: [
                                    for (var col = 0; col < 3; col++) ...[
                                      if (col != 0) const SizedBox(width: 12),
                                      Expanded(child: slots[row * 3 + col]),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      const FeatureBlurbRow(),
                      const SizedBox(height: 24),
                      const PhotoTipsBox(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: BlocBuilder<AddPhotosCubit, AddPhotosState>(
                  builder: (context, state) {
                    final canContinue =
                        state.photos.length >= AddPhotosCubit.minRequiredPhotos;
                    return GradientButton(
                      label: AppStrings.continueLabel,
                      enabled: canContinue,
                      onPressed: () =>
                          context.pushNamed(AppRoute.dashboard.name),
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
