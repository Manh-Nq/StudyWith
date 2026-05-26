import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';
import '../model/math_picture_add_meta.dart';
import '../service/math_picture_add_generator.dart';
import 'math_picture_add_grid_layout.dart';
import 'math_picture_add_layout_metrics.dart';
import 'math_picture_add_problem_layout.dart';

class MathPictureProblemScreen extends StatelessWidget {
  const MathPictureProblemScreen({
    super.key,
    required this.sumLimit,
  });

  final int sumLimit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final MathPictureAddGenerator generator = MathPictureAddGenerator();
    return MathChoiceActivityScreen(
      title: l.mathActPictureTitle,
      traceActivityType: MathActivityType.pictureWordProblem,
      viewModel: MathChoiceActivityViewModel(
        generator: () => generator.generate(l: l, sumLimit: sumLimit),
      ),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        final String item =
            question.meta[MathPictureAddMeta.itemEmoji] ?? '🐔';
        final int left = int.tryParse(
              question.meta[MathPictureAddMeta.leftCount] ?? '',
            ) ??
            0;
        final int right = int.tryParse(
              question.meta[MathPictureAddMeta.rightCount] ?? '',
            ) ??
            0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l.mathPictureAddLayoutHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Size screenSize = MediaQuery.sizeOf(context);
                  final MathPictureAddLayoutMetrics metrics =
                      MathPictureAddLayoutMetrics.fromConstraints(
                    bodyConstraints: constraints,
                    screenSize: screenSize,
                  );
                  final int maxCount = math.max(left, right);
                  final MathPictureCardLayoutBudget budget =
                      metrics.layoutBudget(constraints.maxHeight);
                  final double pictureAreaHeight = budget.pictureHeight;
                  final double groupWidth =
                      metrics.pictureGroupWidth(constraints.maxWidth);
                  final double innerW = metrics.innerWidth(groupWidth);
                  final double innerH = metrics.targetInnerHeight(
                    maxCount: maxCount,
                    maxFrameHeight: pictureAreaHeight,
                    paddingValue: MathPictureAddGridLayout.paddingValue,
                  );
                  final double maxCell = metrics.maxCellSize(maxCount);
                  final double minCell = metrics.minCellSize(maxCount);
                  final double minPictureFrameHeight =
                      metrics.minFrameHeight(maxCount, pictureAreaHeight);
                  final double maxEmojiFontSize = maxCell * 0.9;
                  final MathPictureAddGridLayout sharedLayout =
                      MathPictureAddGridLayout.compute(
                    count: maxCount,
                    innerWidth: innerW,
                    innerHeight: innerH,
                    maxCellOverride: maxCell,
                    minCellOverride: minCell,
                  );
                  return MathPictureAddProblemLayout(
                    leftCount: left,
                    rightCount: right,
                    itemEmoji: item,
                    metrics: metrics,
                    sharedLayout: sharedLayout,
                    minPictureFrameHeight: minPictureFrameHeight,
                    maxEmojiFontSize: maxEmojiFontSize,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
