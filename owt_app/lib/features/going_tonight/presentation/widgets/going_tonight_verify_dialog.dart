import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../cubit/going_tonight_cubit.dart';
import '../cubit/going_tonight_state.dart';
import 'going_tonight_dialog_frame.dart';
import 'going_tonight_icon.dart';
import 'going_tonight_status_row.dart';

/// What the user chose on the success step.
enum GoingTonightOutcome { startMatching, maybeLater }

/// Runs [GoingTonightCubit.verify] and shows its progress, then either the
/// "You're Going Tonight" success card or a failure card. A failure the
/// user can fix in Settings keeps its "Open Settings" action; any other
/// failure just shows its message and closes itself after
/// [_failureAutoClose]. Pops a [GoingTonightOutcome] on success, or null
/// otherwise.
class GoingTonightVerifyDialog extends StatelessWidget {
  const GoingTonightVerifyDialog({
    super.key,
    required this.venueName,
    required this.venueCity,
  });

  final String venueName;

  /// Shown in the "Checking you're near …" row, which is too narrow for the
  /// full venue name.
  final String venueCity;

  static const Duration _failureAutoClose = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoingTonightCubit, GoingTonightState>(
      listenWhen: (previous, current) =>
          current.status == GoingTonightStatus.failure &&
          !_needsSettings(current.failure!),
      listener: (context, state) async {
        final navigator = Navigator.of(context);
        await Future<void>.delayed(_failureAutoClose);
        // Only if the user hasn't already closed it.
        if (navigator.mounted && context.mounted) navigator.pop();
      },
      builder: (context, state) {
        final close = state.status == GoingTonightStatus.verified
            ? null
            : () => Navigator.of(context).pop();
        return GoingTonightDialogFrame(
          onClose: close,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (state.status) {
              GoingTonightStatus.verifying => _VerifyingContent(
                key: const ValueKey('verifying'),
                venueCity: venueCity,
              ),
              GoingTonightStatus.verified => _VerifiedContent(
                key: const ValueKey('verified'),
                venueName: state.clubName ?? venueName,
              ),
              GoingTonightStatus.failure => _FailureContent(
                key: const ValueKey('failure'),
                failure: state.failure!,
                errorMessage: state.errorMessage,
              ),
            },
          ),
        );
      },
    );
  }
}

class _VerifyingContent extends StatelessWidget {
  const _VerifyingContent({super.key, required this.venueCity});

  final String venueCity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GoingTonightIcon(),
        const SizedBox(height: 15),
        const Text(
          AppStrings.goingTonightVerifyingTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightTitle,
        ),
        const SizedBox(height: 15),
        GoingTonightStatusRow(
          label: AppStrings.goingTonightCheckingNear(venueCity),
          done: true,
        ),
        const SizedBox(height: 15),
        const GoingTonightStatusRow(
          label: AppStrings.goingTonightTakesSeconds,
          done: true,
        ),
        const SizedBox(height: 15),
        const GoingTonightStatusRow(
          label: AppStrings.goingTonightKeepLocationOn,
          done: false,
        ),
      ],
    );
  }
}

class _VerifiedContent extends StatelessWidget {
  const _VerifiedContent({super.key, required this.venueName});

  final String venueName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GoingTonightIcon(),
        const SizedBox(height: 15),
        const Text(
          AppStrings.goingTonightSuccessTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightTitle,
        ),
        const SizedBox(height: 15),
        const Text(
          AppStrings.goingTonightSuccessBody,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightBody,
        ),
        const SizedBox(height: 30),
        const Text(
          AppStrings.goingTonightVerifiedFor,
          style: AppTextStyles.goingTonightBody,
        ),
        Text(
          venueName,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightVenue,
        ),
        // Badges always run until 7:00AM, so this is fixed copy rather
        // than the server's expiresAt (which shows in device time).
        const Text(
          AppStrings.goingTonightValidUntil,
          style: AppTextStyles.goingTonightBody,
        ),
        // Figma ends this block with an empty 14px line before the 15px gap.
        const SizedBox(height: 21 + 15),
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            label: AppStrings.goingTonightStartMatching,
            onPressed: () =>
                Navigator.of(context).pop(GoingTonightOutcome.startMatching),
          ),
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () =>
              Navigator.of(context).pop(GoingTonightOutcome.maybeLater),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: GradientText(
              AppStrings.goingTonightMaybeLater,
              gradient: AppGradients.brand,
              style: AppTextStyles.goingTonightSecondaryAction,
            ),
          ),
        ),
      ],
    );
  }
}

/// Failures the user resolves in Settings, so the card stays open with an
/// "Open Settings" action instead of closing itself.
bool _needsSettings(GoingTonightFailure failure) =>
    failure == GoingTonightFailure.locationServiceDisabled ||
    failure == GoingTonightFailure.permissionDeniedForever;

class _FailureContent extends StatelessWidget {
  const _FailureContent({super.key, required this.failure, this.errorMessage});

  final GoingTonightFailure failure;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GoingTonightCubit>();
    final needsSettings = _needsSettings(failure);
    final message = switch (failure) {
      GoingTonightFailure.locationServiceDisabled =>
        AppStrings.goingTonightServiceDisabled,
      GoingTonightFailure.permissionDenied =>
        AppStrings.goingTonightPermissionDenied,
      GoingTonightFailure.permissionDeniedForever =>
        AppStrings.goingTonightPermissionDeniedForever,
      GoingTonightFailure.locationUnavailable =>
        AppStrings.goingTonightLocationUnavailable,
      GoingTonightFailure.checkInFailed =>
        errorMessage ?? AppStrings.somethingWentWrong,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GoingTonightIcon(),
        const SizedBox(height: 15),
        const Text(
          AppStrings.goingTonightFailedTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightTitle,
        ),
        const SizedBox(height: 15),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.goingTonightBody,
        ),
        if (needsSettings) ...[
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: AppStrings.goingTonightOpenSettings,
              onPressed: cubit.openLocationSettings,
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: cubit.verify,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: GradientText(
                AppStrings.retryLabel,
                gradient: AppGradients.brand,
                style: AppTextStyles.goingTonightSecondaryAction,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
