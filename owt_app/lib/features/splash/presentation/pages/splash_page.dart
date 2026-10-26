import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/google_sign_in_cubit.dart';
import '../cubit/google_sign_in_state.dart';
import '../widgets/create_account_prompt.dart';
import '../widgets/splash_legal_notice.dart';
import '../widgets/splash_logo_header.dart';
import '../widgets/splash_social_buttons.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _continueToPhoneNumber(BuildContext context) {
    context.pushNamed(AppRoute.phoneNumber.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GoogleSignInCubit>(),
      child: BlocConsumer<GoogleSignInCubit, GoogleSignInCubitState>(
        listener: (context, state) {
          switch (state.status) {
            case GoogleSignInStatus.loggedIn:
              // Already-registered user — resume onboarding wherever they
              // left it off, or skip straight to the dashboard if complete.
              final user = state.session!.user;
              if (!user.hasInterests) {
                context.pushNamed(AppRoute.interests.name);
              } else if (!user.hasPhotos) {
                context.pushNamed(AppRoute.addPhotos.name);
              } else {
                context.goNamed(AppRoute.dashboard.name);
              }
            case GoogleSignInStatus.needsRegistration:
              // New account — continue into onboarding to finish signup.
              _continueToPhoneNumber(context);
            case GoogleSignInStatus.failure:
              TopNotice.showError(context, state.errorMessage!);
            case GoogleSignInStatus.idle:
            case GoogleSignInStatus.loading:
              break;
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.dark.background,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Assets.images.splashBackground.image(fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.55, 1],
                      colors: [
                        Colors.transparent,
                        AppColors.dark.background.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      const SplashLogoHeader(),
                      const Spacer(flex: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            SplashSocialButtons(
                              onContinueWithGoogle: () =>
                                  context.read<GoogleSignInCubit>().signIn(),
                              onContinueWithFacebook: () =>
                                  _continueToPhoneNumber(context),
                              isGoogleSignInLoading:
                                  state.status == GoogleSignInStatus.loading,
                            ),
                            const SizedBox(height: 24),
                            CreateAccountPrompt(
                              onCreateAccount: () =>
                                  _continueToPhoneNumber(context),
                            ),
                            const SizedBox(height: 17),
                            SplashLegalNotice(
                              onTermsOfUse: () {},
                              onPrivacyPolicy: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Temporary dev shortcut to reach the dashboard without
                // signing in. Debug builds only — never shown in release.
                if (kDebugMode)
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () =>
                            context.goNamed(AppRoute.dashboard.name),
                        child: const Text(
                          'Bypass',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
