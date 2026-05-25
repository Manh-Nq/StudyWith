import 'package:flutter/material.dart';

/// Overlay tròn xanh/đỏ khi trả lời đúng/sai (toán có chấm điểm).
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
                color: (isCorrect ? Colors.green : Colors.red)
                    .withValues(alpha: 0.78),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCorrect ? Icons.check_rounded : Icons.close_rounded,
                size: 84,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
