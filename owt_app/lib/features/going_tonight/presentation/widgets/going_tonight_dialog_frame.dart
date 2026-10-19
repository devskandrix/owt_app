import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';

/// The dark, gray-bordered 300px card every Going Tonight dialog sits in,
/// with an optional close (X) in the top-right corner.
class GoingTonightDialogFrame extends StatelessWidget {
  const GoingTonightDialogFrame({super.key, required this.child, this.onClose});

  final Widget child;
  final VoidCallback? onClose;

  static const Color background = Color(0xFF0D0E0F);
  static const Color border = Color(0xFF344054);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 45, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: child,
                ),
              ),
              if (onClose != null)
                Positioned(
                  top: 6,
                  right: 3,
                  child: GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        Assets.icons.closeWhite,
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
