import 'package:flutter/material.dart';
import '../model/math_picture_item.dart';
import 'math_picture_add_equation_box.dart';
import 'math_picture_add_grid_layout.dart';
import 'math_picture_add_layout_metrics.dart';
import 'math_picture_add_picture_frame.dart';

/// Thẻ bài toán: nhóm tranh + dấu +, phía dưới là thanh phương trình.
class MathPictureAddProblemLayout extends StatelessWidget {
  const MathPictureAddProblemLayout({
    super.key,
    required this.leftCount,
    required this.rightCount,
    required this.item,
    required this.metrics,
    required this.sharedLayout,
    required this.minPictureFrameHeight,
    required this.maxItemSize,
    this.operator = '+',
  });

  final int leftCount;
  final int rightCount;
  final MathPictureItem item;
  final String operator;
  final MathPictureAddLayoutMetrics metrics;
  final MathPictureAddGridLayout sharedLayout;
  final double minPictureFrameHeight;
  final double maxItemSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle plusStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: scheme.primary,
          height: 1,
        ) ??
        TextStyle(
          fontSize: metrics.operatorGlyphSize,
          fontWeight: FontWeight.w800,
          color: scheme.primary,
          height: 1,
        );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MathPictureCardLayoutBudget layoutBudget = metrics.layoutBudget(
          constraints.maxHeight,
        );
        final double cardTotalH = layoutBudget.totalHeight + metrics.cardPadding * 2;
        final Widget card = DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(metrics.cardRadius),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(metrics.cardPadding),
            child: SizedBox(
              height: layoutBudget.totalHeight,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: layoutBudget.pictureHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: MathPictureAddPictureFrame(
                            count: leftCount,
                            item: item,
                            sharedLayout: sharedLayout,
                            maxFrameHeight: layoutBudget.pictureHeight,
                            minFrameHeight: minPictureFrameHeight,
                            maxItemSize: maxItemSize,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: metrics.groupGap / 2,
                          ),
                          child: Center(
                            child: Text(operator, style: plusStyle),
                          ),
                        ),
                        Expanded(
                          child: MathPictureAddPictureFrame(
                            count: rightCount,
                            item: item,
                            sharedLayout: sharedLayout,
                            maxFrameHeight: layoutBudget.pictureHeight,
                            minFrameHeight: minPictureFrameHeight,
                            maxItemSize: maxItemSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (layoutBudget.sectionGap > 0)
                    SizedBox(height: layoutBudget.sectionGap),
                  SizedBox(
                    height: layoutBudget.equationHeight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: MathPictureAddEquationBar(
                        leftCount: leftCount,
                        rightCount: rightCount,
                        metrics: metrics,
                        operator: operator,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: constraints.maxHeight,
            ),
            child: cardTotalH > constraints.maxHeight
                ? SingleChildScrollView(
                    child: card,
                  )
                : card,
          ),
        );
      },
    );
  }
}
