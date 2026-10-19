import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';

/// Full-height placeholder shown under the search bar when the dashboard
/// has nothing to list — either the request failed or every club list came
/// back empty. Scrollable so pull-to-refresh still works around it.
class DashboardStatusView extends StatelessWidget {
  const DashboardStatusView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppGradients.brand.createShader(bounds),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 20,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.authSubtitle.copyWith(
                  fontSize: 14,
                  color: colors.textMuted,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 180,
                child: GradientButton(
                  label: AppStrings.retryLabel,
                  onPressed: onRetry,
                ),
              ),
              // Lift the block slightly above true center so it doesn't
              // read as sitting low above the bottom nav.
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
