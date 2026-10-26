import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// The "Message" title above the chat list.
class MessagesHeader extends StatelessWidget {
  const MessagesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          AppStrings.messagesSectionTitle,
          style: AppTextStyles.messagesSection.copyWith(
            color: context.appColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
