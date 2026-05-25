import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';
import '../model/math_picture_add_meta.dart';
import '../service/math_picture_add_generator.dart';
import 'math_picture_add_count_column.dart';
import 'math_picture_add_grid_layout.dart';

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
        const double numberLabelHeight = 52;
        const double sideGutter = 6;
        const double equalsSlot = 56;
        const double frameInset = 20;
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
                  final double rowHeight = constraints.maxHeight;
                  final double maxFrameHeight = rowHeight - numberLabelHeight;
                  final double totalWidth = constraints.maxWidth;
                  const double plusSlot = 36;
                  final double pairWidth = (totalWidth -
                          plusSlot -
                          equalsSlot -
                          sideGutter * 4) /
                      2;
                  final double innerW = math.max(1, pairWidth - frameInset);
                  final double innerH = math.max(
                    1,
                    maxFrameHeight -
                        MathPictureAddGridLayout.paddingValue * 2,
                  );
                  final MathPictureAddGridLayout sharedLayout =
                      MathPictureAddGridLayout.compute(
                    count: math.max(left, right),
                    innerWidth: innerW,
                    innerHeight: innerH,
                  );
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: MathPictureAddCountColumn(
                          count: left,
                          itemEmoji: item,
                          sharedLayout: sharedLayout,
                          maxFrameHeight: maxFrameHeight,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: sideGutter),
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MathPictureAddCountColumn(
                          count: right,
                          itemEmoji: item,
                          sharedLayout: sharedLayout,
                          maxFrameHeight: maxFrameHeight,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: sideGutter),
                        child: Center(
                          child: Text(
                            '=',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: equalsSlot,
                        child: Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),
                    ],
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
