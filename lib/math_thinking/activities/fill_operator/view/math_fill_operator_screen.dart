import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathFillOperatorScreen extends StatelessWidget {
  const MathFillOperatorScreen({super.key});

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final List<String> ops = <String>['+', '-', '='];
    final String correct = ops[r.nextInt(ops.length)];
    int a = 1 + r.nextInt(9);
    int b = 1 + r.nextInt(9);
    int c = 0;
    if (correct == '+') {
      c = a + b;
    } else if (correct == '-') {
      if (b > a) {
        final int t = a;
        a = b;
        b = t;
      }
      c = a - b;
    } else {
      b = a;
      c = a;
    }
    final List<String> options = List<String>.from(ops)..shuffle(r);
    return MathChoiceQuestion(
      questionText: '$a  ?  $b  =  $c',
      options: options,
      correctIndex: options.indexOf(correct),
      hintText: l.mathActFillOpDesc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActFillOpTitle,
      traceActivityType: MathActivityType.fillMathOperator,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        return Center(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
          ),
        );
      },
    );
  }
}
