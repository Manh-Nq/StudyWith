import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathPositionScreen extends StatelessWidget {
  const MathPositionScreen({super.key});

  static const List<String> _positionKeys = <String>[
    'top',
    'bottom',
    'left',
    'right',
  ];

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final String pos = _positionKeys[r.nextInt(_positionKeys.length)];
    final List<String> options = List<String>.from(_positionKeys)..shuffle(r);
    return MathChoiceQuestion(
      questionText: pos,
      options: options,
      correctIndex: options.indexOf(pos),
      hintText: l.mathActPositionDesc,
    );
  }

  static String _optionLabel(BuildContext context, String key) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    switch (key) {
      case 'top':
        return l.mathPositionTop;
      case 'bottom':
        return l.mathPositionBottom;
      case 'left':
        return l.mathPositionLeft;
      case 'right':
        return l.mathPositionRight;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActPositionTitle,
      traceActivityType: MathActivityType.identifyPosition,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      optionLabelBuilder:
          (BuildContext c, int index, String optionValue) =>
              _optionLabel(c, optionValue),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        final String pos = question.questionText;
        Alignment dot = Alignment.center;
        if (pos == 'top') {
          dot = const Alignment(0, -0.75);
        } else if (pos == 'bottom') {
          dot = const Alignment(0, 0.75);
        } else if (pos == 'left') {
          dot = const Alignment(-0.75, 0);
        } else if (pos == 'right') {
          dot = const Alignment(0.75, 0);
        }
        return Center(
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Align(
              alignment: dot,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: Colors.purple, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      },
    );
  }
}
