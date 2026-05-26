import 'dart:math';

import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/shared/model/math_entity_type.dart';
import 'package:location_app/math_thinking/shared/ui/math_activity_dialogs.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../model/math_picture_add_meta.dart';
import '../model/math_picture_item.dart';
import '../model/math_picture_operation_mode.dart';

class MathPictureProblemGenerator {
  MathPictureProblemGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const List<String> _defaultEmojis = <String>[
    '🐔',
    '🍎',
    '⚽',
    '🐟',
    '🐶',
  ];

  MathChoiceQuestion generate({
    required AppLocalizations l,
    required int limit,
    required MathPictureOperationMode mode,
    List<MathEntityType> entities = const <MathEntityType>[],
  }) {
    final int safeLimit = limit.clamp(
      mathPictureSumLimitMin,
      mathPictureSumLimitMax,
    );
    final MathPictureOperationMode op = mode.resolve(_random);
    final MathPictureItem item = _pickItem(entities);
    if (op == MathPictureOperationMode.subtraction) {
      return _generateSubtraction(l: l, safeLimit: safeLimit, item: item);
    }
    return _generateAddition(l: l, safeLimit: safeLimit, item: item);
  }

  MathPictureItem _pickItem(List<MathEntityType> entities) {
    final int emojiCount = _defaultEmojis.length;
    final int entityCount = entities.length;
    final int poolSize = emojiCount + entityCount;
    final int index = _random.nextInt(poolSize);
    if (index < emojiCount) {
      return MathPictureItem.emoji(_defaultEmojis[index]);
    }
    return MathPictureItem.entity(entities[index - emojiCount]);
  }

  Map<String, String> _metaWithItem(
    MathPictureItem item,
    Map<String, String> base,
  ) {
    return <String, String>{
      ...item.toMeta(),
      ...base,
    };
  }

  /// Cặp (a, b) với a≥1, b≥1, a+b≤[limit] — phân phối đều (không lệch phải > trái).
  (int left, int right) _randomAdditionOperands(int limit) {
    final int pairCount = limit * (limit - 1) ~/ 2;
    int index = _random.nextInt(pairCount);
    for (int left = 1; left < limit; left++) {
      final int rightSpan = limit - left;
      if (index < rightSpan) {
        return (left, index + 1);
      }
      index -= rightSpan;
    }
    return (1, 1);
  }

  MathChoiceQuestion _generateAddition({
    required AppLocalizations l,
    required int safeLimit,
    required MathPictureItem item,
  }) {
    final (int left, int right) = _randomAdditionOperands(safeLimit);
    final int sum = left + right;
    final List<String> options = _buildOptions(correct: sum, safeLimit: safeLimit);
    return MathChoiceQuestion(
      questionText: '$left + $right = ?',
      options: options,
      correctIndex: options.indexOf(sum.toString()),
      hintText: l.mathPictureAddCountHint,
      meta: _metaWithItem(
        item,
        <String, String>{
          MathPictureAddMeta.operation: 'add',
          MathPictureAddMeta.leftCount: left.toString(),
          MathPictureAddMeta.rightCount: right.toString(),
          MathPictureAddMeta.sum: sum.toString(),
          MathPictureAddMeta.answer: sum.toString(),
        },
      ),
    );
  }

  MathChoiceQuestion _generateSubtraction({
    required AppLocalizations l,
    required int safeLimit,
    required MathPictureItem item,
  }) {
    final int left = 2 + _random.nextInt(safeLimit - 1);
    final int right = 1 + _random.nextInt(left - 1);
    final int answer = left - right;
    final List<String> options = _buildOptions(
      correct: answer,
      safeLimit: safeLimit,
    );
    return MathChoiceQuestion(
      questionText: '$left - $right = ?',
      options: options,
      correctIndex: options.indexOf(answer.toString()),
      hintText: l.mathPictureSubtractCountHint,
      meta: _metaWithItem(
        item,
        <String, String>{
          MathPictureAddMeta.operation: 'subtract',
          MathPictureAddMeta.leftCount: left.toString(),
          MathPictureAddMeta.rightCount: right.toString(),
          MathPictureAddMeta.answer: answer.toString(),
        },
      ),
    );
  }

  List<String> _buildOptions({
    required int correct,
    required int safeLimit,
  }) {
    final Set<int> optionSet = <int>{correct};
    while (optionSet.length < 3) {
      final int delta = 1 + _random.nextInt(3);
      final int candidate = correct + (_random.nextBool() ? delta : -delta);
      if (candidate > 0 && candidate <= safeLimit + 2) {
        optionSet.add(candidate);
      }
    }
    return optionSet.map((int e) => e.toString()).toList()..shuffle(_random);
  }
}
