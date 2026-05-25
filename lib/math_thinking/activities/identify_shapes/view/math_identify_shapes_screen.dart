import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/model/math_activity_type.dart';

import '../../../shared/view/math_entity_image_widget.dart';
import '../../../shared/model/math_entity_type.dart';
import '../../shared_choice/model/math_choice_question.dart';
import '../../shared_choice/view/math_choice_activity_screen.dart';
import '../../shared_choice/view_model/math_choice_activity_view_model.dart';

class MathIdentifyShapesScreen extends StatelessWidget {
  const MathIdentifyShapesScreen({super.key});

  static const List<String> _shapeValues = <String>[
    'circle',
    'square',
    'rectangle',
    'triangle',
    'star',
  ];

  MathChoiceQuestion _generate(AppLocalizations l) {
    final Random r = Random();
    final String correctValue = _shapeValues[r.nextInt(_shapeValues.length)];
    final List<String> options =
        List<String>.from(_shapeValues)..shuffle(r);
    final List<String> sliced = options.take(3).toList();
    if (!sliced.contains(correctValue)) {
      sliced[0] = correctValue;
    }
    sliced.shuffle(r);
    return MathChoiceQuestion(
      questionText: correctValue,
      options: sliced,
      correctIndex: sliced.indexOf(correctValue),
      hintText: l.mathActShapesDesc,
    );
  }

  static String _shapeLabel(BuildContext context, String value) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    switch (value) {
      case 'circle':
        return l.mathEntityShapeCircle;
      case 'square':
        return l.mathEntityShapeSquare;
      case 'rectangle':
        return l.mathEntityShapeRectangle;
      case 'triangle':
        return l.mathEntityShapeTriangle;
      case 'star':
        return l.mathEntityShapeStar;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return MathChoiceActivityScreen(
      title: l.mathActShapesTitle,
      traceActivityType: MathActivityType.identifyShapes,
      viewModel: MathChoiceActivityViewModel(
        generator: () => _generate(l),
      ),
      optionLabelBuilder:
          (BuildContext c, int index, String optionValue) =>
              _shapeLabel(c, optionValue),
      bodyBuilder: (BuildContext context, MathChoiceQuestion question) {
        final MathEntityType entity = MathEntityType(
          id: 0,
          name: 'shape',
          imageKind: MathEntityImageKind.vector,
          imageValue: question.questionText,
          isActive: true,
          createdAtEpochMs: 0,
          updatedAtEpochMs: 0,
        );
        return Center(
          child: MathEntityImageWidget(entity: entity, size: 160),
        );
      },
    );
  }
}
