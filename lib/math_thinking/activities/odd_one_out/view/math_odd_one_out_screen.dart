import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathOddOneOutScreen extends StatelessWidget {
  const MathOddOneOutScreen({super.key});

  static const List<List<String>> _groups = <List<String>>[
    <String>['🐶', '🐱', '🐰', '🚗'],
    <String>['🍎', '🍌', '🍇', '⚽'],
    <String>['🚌', '🚲', '🚗', '🐟'],
  ];

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final List<String> group =
        List<String>.from(_groups[r.nextInt(_groups.length)]);
    final String odd = group.last;
    group.shuffle(r);
    final List<String> options = List<String>.from(group);
    return MathChoiceQuestion(
      questionText: group.join('  '),
      options: options,
      correctIndex: options.indexOf(odd),
      hintText: l.mathActOddOneDesc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActOddOneTitle,
      traceActivityType: MathActivityType.oddOneOut,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        return Center(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 54),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
