import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Four boxes for entering a one-time verification code, matching the
/// "Verification" frame in Figma. Auto-advances focus as digits are typed
/// and reports the combined code via [onChanged] on every keystroke.
class OtpCodeRow extends StatefulWidget {
  const OtpCodeRow({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  State<OtpCodeRow> createState() => _OtpCodeRowState();
}

class _OtpCodeRowState extends State<OtpCodeRow> {
  static const _length = 4;
  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged?.call(_controllers.map((c) => c.text).join());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _length; i++) ...[
          if (i != 0) const SizedBox(width: 12),
          SizedBox(
            width: 64,
            height: 64,
            child: TextField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              onChanged: (value) => _onChanged(i, value),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.otpDigit.copyWith(color: colors.textOtpFilled),
              decoration: InputDecoration(
                counterText: '',
                hintText: AppStrings.otpEmptyPlaceholder,
                hintStyle: AppTextStyles.otpDigit.copyWith(color: AppColors.otpEmptyText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.otpBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.otpBorder),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
