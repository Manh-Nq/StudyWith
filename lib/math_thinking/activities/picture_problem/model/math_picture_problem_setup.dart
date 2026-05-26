import 'math_picture_operation_mode.dart';

/// Cấu hình khi bắt đầu bài toán có tranh.
class MathPictureProblemSetup {
  const MathPictureProblemSetup({
    required this.limit,
    required this.mode,
  });

  final int limit;
  final MathPictureOperationMode mode;
}
