import 'dart:math';

import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/math_thinking/shared/ui/math_activity_dialogs.dart';

import '../../shared_choice/model/math_choice_question.dart';
import '../model/math_picture_add_meta.dart';

class MathPictureAddGenerator {
  MathPictureAddGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const List<String> _itemEmojis = <String>['🐔', '🍎', '⚽', '🐟', '🐶'];

  MathChoiceQuestion generate({
    required AppLocalizations l,
    required int sumLimit,
  }) {
    final int safeLimit = sumLimit.clamp(
      mathPictureSumLimitMin,
      mathPictureSumLimitMax,
    );
    final int left = 1 + _random.nextInt(safeLimit - 1);
    final int maxRight = safeLimit - left;
    final int right = 1 + _random.nextInt(maxRight);
    final int sum = left + right;
    final String item = _itemEmojis[_random.nextInt(_itemEmojis.length)];
    final Set<int> optionSet = <int>{sum};
    while (optionSet.length < 3) {
      final int delta = 1 + _random.nextInt(3);
      final int candidate = sum + (_random.nextBool() ? delta : -delta);
      if (candidate > 0 && candidate <= safeLimit + 2) {
        optionSet.add(candidate);
      }
    }
    final List<String> options = optionSet.map((int e) => e.toString()).toList()
      ..shuffle(_random);
    return MathChoiceQuestion(
      questionText: '$left + $right = ?',
      options: options,
      correctIndex: options.indexOf(sum.toString()),
      hintText: l.mathPictureAddCountHint,
      meta: <String, String>{
        MathPictureAddMeta.itemEmoji: item,
        MathPictureAddMeta.leftCount: left.toString(),
        MathPictureAddMeta.rightCount: right.toString(),
        MathPictureAddMeta.sum: sum.toString(),
      },
    );
  }
}
