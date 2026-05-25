import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathSameDifferentScreen extends StatelessWidget {
  const MathSameDifferentScreen({super.key});

  static const String _same = 'same';
  static const String _different = 'different';

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    const List<String> source = <String>['🔷', '🔷', '🔶'];
    final List<String> same = List<String>.from(source);
    same.shuffle(r);
    final String display = same.join('   ');
    final List<String> options = <String>[_same, _different];
    const int correct = 1;
    return MathChoiceQuestion(
      questionText: display,
      options: options,
      correctIndex: correct,
      hintText: l.mathActSameDiffDesc,
    );
  }

  static String _optionLabel(BuildContext context, String key) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    switch (key) {
      case _same:
        return l.mathSameAnswerSame;
      case _different:
        return l.mathSameAnswerDifferent;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActSameDiffTitle,
      traceActivityType: MathActivityType.findSameDifferent,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      optionLabelBuilder:
          (BuildContext c, int index, String optionValue) =>
              _optionLabel(c, optionValue),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        return Center(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900),
          ),
        );
      },
    );
  }
}
