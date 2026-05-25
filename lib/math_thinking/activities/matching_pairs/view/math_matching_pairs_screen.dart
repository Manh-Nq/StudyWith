import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathMatchingPairsScreen extends StatelessWidget {
  const MathMatchingPairsScreen({super.key});

  static const List<Map<String, Object>> _pairs = <Map<String, Object>>[
    <String, Object>{
      'left': '🐱',
      'right': '🐟',
      'choices': <String>['🐟', '🥕', '🌿']
    },
    <String, Object>{
      'left': '🐰',
      'right': '🥕',
      'choices': <String>['🥕', '🍖', '🐟']
    },
    <String, Object>{
      'left': '🚗',
      'right': '⛽',
      'choices': <String>['⛽', '💧', '🍎']
    },
  ];

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final Map<String, Object> item = _pairs[r.nextInt(_pairs.length)];
    final String left = item['left']! as String;
    final String right = item['right']! as String;
    final List<String> options =
        List<String>.from(item['choices']! as List<String>)..shuffle(r);
    return MathChoiceQuestion(
      questionText: '$left  ->  ?',
      options: options,
      correctIndex: options.indexOf(right),
      hintText: l.mathActMatchingDesc,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActMatchingTitle,
      traceActivityType: MathActivityType.matchingPairs,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        return Center(
          child: Text(
            question.questionText,
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900),
          ),
        );
      },
    );
  }
}
