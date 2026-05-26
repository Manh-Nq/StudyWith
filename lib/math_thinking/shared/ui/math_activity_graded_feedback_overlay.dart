import 'package:flutter/material.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';

/// Overlay tròn khi trả lời đúng/sai — màu mềm, không đỏ/xanh gắt.
class MathActivityGradedFeedbackOverlay extends StatelessWidget {
  const MathActivityGradedFeedbackOverlay({
    super.key,
    required this.show,
    required this.isCorrect,
  });

  final bool show;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final AppSemanticColors semantic = context.semanticColors;
    final Color fill =
        isCorrect ? semantic.success : semantic.tryAgain;
    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 260),
        opacity: show ? 1 : 0,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 520),
            tween: Tween<double>(
              begin: show ? 0.7 : 1.0,
              end: show ? 1.0 : 1.0,
            ),
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 132,
              height: 132,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill.withValues(alpha: 0.88),
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: fill.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                isCorrect ? Icons.check_rounded : Icons.cancel_rounded,
                size: isCorrect ? 84 : 80,
                color: KidFriendlyColors.onDarkText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
