import 'dart:math';

import '../model/math_compare_question.dart';
import '../../../shared/model/math_entity_type.dart';

class MathCompareGenerator {
  MathCompareGenerator({Random? random}) : _random = random ?? Random();
  final Random _random;

  MathCompareQuestion generate(List<MathEntityType> entities) {
    if (entities.isEmpty) {
      throw StateError('No active entities found');
    }
    final MathEntityType selected = entities[_random.nextInt(entities.length)];
    int leftCount = 1 + _random.nextInt(9);
    int rightCount = 1 + _random.nextInt(9);
    final int mode = _random.nextInt(3);
    if (mode == 0) {
      rightCount = leftCount;
    } else if (mode == 1) {
      if (leftCount <= rightCount) {
        leftCount = min(10, rightCount + 1);
      }
    } else {
      if (leftCount >= rightCount) {
        leftCount = max(1, rightCount - 1);
      }
    }
    MathCompareRelation relation = MathCompareRelation.equal;
    if (leftCount > rightCount) {
      relation = MathCompareRelation.more;
    } else if (leftCount < rightCount) {
      relation = MathCompareRelation.less;
    }
    final List<MathCompareRelation> options = <MathCompareRelation>[
      MathCompareRelation.more,
      MathCompareRelation.less,
      MathCompareRelation.equal,
    ]..shuffle(_random);
    return MathCompareQuestion(
      leftEntity: selected,
      rightEntity: selected,
      leftCount: leftCount,
      rightCount: rightCount,
      correctRelation: relation,
      options: options,
    );
  }
}
