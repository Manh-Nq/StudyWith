import 'dart:math';

/// Phép tính cho bài toán có tranh.
enum MathPictureOperationMode {
  addition,
  subtraction,
  mixed;

  /// Chọn ngẫu nhiên cộng hoặc trừ khi [mixed].
  MathPictureOperationMode resolve(Random random) {
    if (this != MathPictureOperationMode.mixed) {
      return this;
    }
    return random.nextBool()
        ? MathPictureOperationMode.addition
        : MathPictureOperationMode.subtraction;
  }

  String get metaValue {
    switch (this) {
      case MathPictureOperationMode.addition:
        return 'add';
      case MathPictureOperationMode.subtraction:
        return 'subtract';
      case MathPictureOperationMode.mixed:
        return 'mixed';
    }
  }

  static bool metaIsSubtraction(String? value) {
    return value == 'subtract';
  }
}
