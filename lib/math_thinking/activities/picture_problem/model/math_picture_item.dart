import 'package:location_app/math_thinking/shared/model/math_entity_meta_codec.dart';
import 'package:location_app/math_thinking/shared/model/math_entity_type.dart';

import 'math_picture_add_meta.dart';

/// Vật minh hoạ: emoji mặc định hoặc vật do người dùng thêm.
sealed class MathPictureItem {
  const MathPictureItem();

  const factory MathPictureItem.emoji(String emoji) = MathPictureEmojiItem;

  const factory MathPictureItem.entity(MathEntityType entity) =
      MathPictureEntityItem;

  static MathPictureItem? fromMeta(Map<String, String> meta) {
    final String kind = meta[MathPictureAddMeta.itemKind] ?? '';
    if (kind == MathPictureAddMeta.itemKindEmoji) {
      final String emoji = meta[MathPictureAddMeta.itemEmoji] ?? '';
      if (emoji.isEmpty) {
        return null;
      }
      return MathPictureItem.emoji(emoji);
    }
    if (kind == MathPictureAddMeta.itemKindEntity) {
      final MathEntityType? entity = MathEntityMetaCodec.fromMeta(meta);
      if (entity == null) {
        return null;
      }
      return MathPictureItem.entity(entity);
    }
    return null;
  }

  Map<String, String> toMeta() {
    switch (this) {
      case MathPictureEmojiItem(:final String emoji):
        return <String, String>{
          MathPictureAddMeta.itemKind: MathPictureAddMeta.itemKindEmoji,
          MathPictureAddMeta.itemEmoji: emoji,
        };
      case MathPictureEntityItem(:final MathEntityType entity):
        return <String, String>{
          MathPictureAddMeta.itemKind: MathPictureAddMeta.itemKindEntity,
          ...MathEntityMetaCodec.toMeta(entity),
        };
    }
  }
}

final class MathPictureEmojiItem extends MathPictureItem {
  const MathPictureEmojiItem(this.emoji);
  final String emoji;
}

final class MathPictureEntityItem extends MathPictureItem {
  const MathPictureEntityItem(this.entity);
  final MathEntityType entity;
}
