import 'math_entity_type.dart';

/// Meta keys for embedding [MathEntityType] in activity question maps.
abstract final class MathEntityMetaKeys {
  static const String entityId = 'entityId';
  static const String entityName = 'entityName';
  static const String entityImageKind = 'entityImageKind';
  static const String entityImageValue = 'entityImageValue';
}

abstract final class MathEntityMetaCodec {
  static Map<String, String> toMeta(MathEntityType entity) {
    return <String, String>{
      MathEntityMetaKeys.entityId: entity.id.toString(),
      MathEntityMetaKeys.entityName: entity.name,
      MathEntityMetaKeys.entityImageKind: _imageKindToMeta(entity.imageKind),
      MathEntityMetaKeys.entityImageValue: entity.imageValue,
    };
  }

  static MathEntityType? fromMeta(Map<String, String> meta) {
    final int? id = int.tryParse(meta[MathEntityMetaKeys.entityId] ?? '');
    if (id == null) {
      return null;
    }
    final String name = meta[MathEntityMetaKeys.entityName] ?? '';
    final MathEntityImageKind? kind =
        _imageKindFromMeta(meta[MathEntityMetaKeys.entityImageKind]);
    if (kind == null) {
      return null;
    }
    return MathEntityType(
      id: id,
      name: name,
      imageKind: kind,
      imageValue: meta[MathEntityMetaKeys.entityImageValue] ?? '',
      isActive: true,
      createdAtEpochMs: 0,
      updatedAtEpochMs: 0,
    );
  }

  static String _imageKindToMeta(MathEntityImageKind kind) {
    switch (kind) {
      case MathEntityImageKind.vector:
        return 'vector';
      case MathEntityImageKind.base64:
        return 'base64';
      case MathEntityImageKind.url:
        return 'url';
    }
  }

  static MathEntityImageKind? _imageKindFromMeta(String? value) {
    switch (value) {
      case 'vector':
        return MathEntityImageKind.vector;
      case 'base64':
        return MathEntityImageKind.base64;
      case 'url':
        return MathEntityImageKind.url;
      default:
        return null;
    }
  }
}
