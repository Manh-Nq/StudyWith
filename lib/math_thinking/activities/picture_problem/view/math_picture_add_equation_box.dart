import 'package:flutter/material.dart';

import 'math_picture_add_layout_metrics.dart';

/// Thanh phương trình một dòng: [số] + [số] = [?] (kiểu app học toán).
class MathPictureAddEquationBar extends StatelessWidget {
  const MathPictureAddEquationBar({
    super.key,
    required this.leftCount,
    required this.rightCount,
    required this.metrics,
    this.operator = '+',
  });

  final int leftCount;
  final int rightCount;
  final MathPictureAddLayoutMetrics metrics;
  final String operator;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextStyle operatorStyle = theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: scheme.onSurfaceVariant,
          height: 1,
        ) ??
        TextStyle(
          fontSize: metrics.operatorGlyphSize,
          fontWeight: FontWeight.w800,
          color: scheme.onSurfaceVariant,
          height: 1,
        );
    return SizedBox(
      height: metrics.equationBarOuterHeight(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.equationChipGap * 1.5,
            vertical: metrics.equationChipGap,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _EquationChip(
                  label: '$leftCount',
                  metrics: metrics,
                  fontSize: metrics.numberFontSize,
                  background: scheme.surface,
                  foreground: scheme.primary,
                ),
                SizedBox(width: metrics.equationChipGap),
                Text(operator, style: operatorStyle),
                SizedBox(width: metrics.equationChipGap),
                _EquationChip(
                  label: '$rightCount',
                  metrics: metrics,
                  fontSize: metrics.numberFontSize,
                  background: scheme.surface,
                  foreground: scheme.primary,
                ),
                SizedBox(width: metrics.equationChipGap),
                Text('=', style: operatorStyle),
                SizedBox(width: metrics.equationChipGap),
                _EquationChip(
                  label: '?',
                  metrics: metrics,
                  fontSize: metrics.questionFontSize,
                  background: scheme.primaryContainer,
                  foreground: scheme.onPrimaryContainer,
                  emphasized: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EquationChip extends StatelessWidget {
  const _EquationChip({
    required this.label,
    required this.metrics,
    required this.fontSize,
    required this.background,
    required this.foreground,
    this.emphasized = false,
  });

  final String label;
  final MathPictureAddLayoutMetrics metrics;
  final double fontSize;
  final Color background;
  final Color foreground;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final double chipHeight =
        metrics.equationBarHeight - metrics.equationChipGap * 2;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: metrics.equationChipMinWidth,
        minHeight: chipHeight,
        maxHeight: chipHeight,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: emphasized
              ? null
              : Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.5),
                ),
          boxShadow: emphasized
              ? <BoxShadow>[
                  BoxShadow(
                    color: foreground.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                color: foreground,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
