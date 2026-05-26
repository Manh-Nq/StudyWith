import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathSizeCompareScreen extends StatelessWidget {
  const MathSizeCompareScreen({super.key});

  static const String _leftBigger = 'left_bigger';
  static const String _rightBigger = 'right_bigger';
  static const String _equal = 'equal';

  /// Sizes are edge lengths in logical pixels. Unequal pairs always differ
  /// enough for young learners (min gap + min ratio vs the smaller side).
  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final List<String> options = <String>[
      _leftBigger,
      _rightBigger,
      _equal,
    ];
    final int mode = r.nextInt(10);
    late final int left;
    late final int right;
    late final int correct;
    if (mode == 0) {
      final int s = 72 + r.nextInt(36);
      left = s;
      right = s;
      correct = 2;
    } else {
      final int small = 56 + r.nextInt(28);
      final int minLarge = max(
        small + 44,
        (small * 1.55).ceil(),
      );
      final int large = minLarge + r.nextInt(48);
      final bool putBiggerOnLeft = r.nextBool();
      if (putBiggerOnLeft) {
        left = large;
        right = small;
        correct = 0;
      } else {
        left = small;
        right = large;
        correct = 1;
      }
    }
    return MathChoiceQuestion(
      questionText: '$left,$right',
      options: options,
      correctIndex: correct,
      hintText: l.mathActSizeCompareDesc,
    );
  }

  static String _optionLabel(BuildContext context, String key) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    switch (key) {
      case _leftBigger:
        return l.mathSizeCompareOptionLeftBigger;
      case _rightBigger:
        return l.mathSizeCompareOptionRightBigger;
      case _equal:
        return l.mathSizeCompareOptionEqual;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActSizeCompareTitle,
      traceActivityType: MathActivityType.compareSizeHeightLength,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      optionLabelBuilder:
          (BuildContext c, int index, String optionValue) =>
              _optionLabel(c, optionValue),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        final List<String> parts = question.questionText.split(',');
        final double left = double.parse(parts[0]);
        final double right = double.parse(parts[1]);
        final ColorScheme scheme = Theme.of(context).colorScheme;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _CompareSquare(
                    size: left,
                    color: KidFriendlyColors.skyPrimary.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 32),
                  _CompareSquare(
                    size: right,
                    color: KidFriendlyColors.warmCoral.withValues(alpha: 0.85),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: max(left, right) * 2 + 48,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompareSquare extends StatelessWidget {
  const _CompareSquare({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outline, width: 2),
      ),
    );
  }
}
