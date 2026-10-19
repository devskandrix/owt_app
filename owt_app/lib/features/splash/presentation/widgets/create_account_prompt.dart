import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';

/// "New Here ?" / "Create Account →" call to action shown below the social
/// sign-in buttons.
class CreateAccountPrompt extends StatelessWidget {
  const CreateAccountPrompt({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppStrings.newHere, style: AppTextStyles.prompt),
        const SizedBox(height: 4),
        InkWell(
          onTap: onCreateAccount,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientText(
                AppStrings.createAccount,
                gradient: AppGradients.brand,
                style: AppTextStyles.link,
              ),
              const SizedBox(width: 7),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) =>
                    AppGradients.brand.createShader(bounds),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
