import 'package:flutter/material.dart';
import 'package:location_app/math_thinking/shared/model/math_entity_type.dart';
import 'package:location_app/math_thinking/shared/view/math_entity_image_widget.dart';

import '../model/math_picture_item.dart';

/// Hiển thị một vật minh hoạ (emoji hoặc ảnh/hình vector tùy chỉnh).
class MathPictureItemWidget extends StatelessWidget {
  const MathPictureItemWidget({
    super.key,
    required this.item,
    required this.size,
  });

  final MathPictureItem item;
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (item) {
      case MathPictureEmojiItem(:final String emoji):
        return Text(
          emoji,
          style: TextStyle(fontSize: size, height: 1),
        );
      case MathPictureEntityItem(:final MathEntityType entity):
        return MathEntityImageWidget(entity: entity, size: size);
    }
  }
}
