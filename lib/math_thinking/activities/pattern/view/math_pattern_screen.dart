import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathPatternScreen extends StatelessWidget {
  const MathPatternScreen({super.key});

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final String a = r.nextBool() ? '🔴' : '⭐';
    final String b = a == '🔴' ? '🔵' : '⚫';
    final String seq = '$a $b $a $b $a ?';
    final List<String> options = <String>[b, a, '🟢']..shuffle(r);
    return MathChoiceQuestion(
      questionText: seq,
      options: options,
      correctIndex: options.indexOf(b),
      hintText: l.mathActPatternDesc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActPatternTitle,
      traceActivityType: MathActivityType.completePattern,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        return Center(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
