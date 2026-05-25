import '../../../shared/model/math_entity_type.dart';

enum MathCompareRelation { more, less, equal }

class MathCompareQuestion {
  const MathCompareQuestion({
    required this.leftEntity,
    required this.rightEntity,
    required this.leftCount,
    required this.rightCount,
    required this.correctRelation,
    required this.options,
  });
  final MathEntityType leftEntity;
  final MathEntityType rightEntity;
  final int leftCount;
  final int rightCount;
  final MathCompareRelation correctRelation;
  final List<MathCompareRelation> options;
}
