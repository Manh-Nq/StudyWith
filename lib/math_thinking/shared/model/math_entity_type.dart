enum MathEntityImageKind { vector, base64, url }

class MathEntityType {
  const MathEntityType({
    required this.id,
    required this.name,
    required this.imageKind,
    required this.imageValue,
    required this.isActive,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
  });
  final int id;
  final String name;
  final MathEntityImageKind imageKind;
  final String imageValue;
  final bool isActive;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;

  MathEntityType copyWith({
    int? id,
    String? name,
    MathEntityImageKind? imageKind,
    String? imageValue,
    bool? isActive,
    int? createdAtEpochMs,
    int? updatedAtEpochMs,
  }) {
    return MathEntityType(
      id: id ?? this.id,
      name: name ?? this.name,
      imageKind: imageKind ?? this.imageKind,
      imageValue: imageValue ?? this.imageValue,
      isActive: isActive ?? this.isActive,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'image_kind': _imageKindToDbValue(imageKind),
      'image_value': imageValue,
      'is_active': isActive ? 1 : 0,
      'created_at_epoch_ms': createdAtEpochMs,
      'updated_at_epoch_ms': updatedAtEpochMs,
    };
  }

  static MathEntityType fromMap(Map<String, Object?> map) {
    return MathEntityType(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: (map['name'] as String?) ?? '',
      imageKind: _imageKindFromDbValue((map['image_kind'] as String?) ?? 'url'),
      imageValue: (map['image_value'] as String?) ?? '',
      isActive: ((map['is_active'] as num?)?.toInt() ?? 0) == 1,
      createdAtEpochMs: (map['created_at_epoch_ms'] as num?)?.toInt() ?? 0,
      updatedAtEpochMs: (map['updated_at_epoch_ms'] as num?)?.toInt() ?? 0,
    );
  }

  static String _imageKindToDbValue(MathEntityImageKind kind) {
    switch (kind) {
      case MathEntityImageKind.vector:
        return 'vector';
      case MathEntityImageKind.base64:
        return 'base64';
      case MathEntityImageKind.url:
        return 'url';
    }
  }

  static MathEntityImageKind _imageKindFromDbValue(String value) {
    switch (value) {
      case 'vector':
        return MathEntityImageKind.vector;
      case 'base64':
        return MathEntityImageKind.base64;
      default:
        return MathEntityImageKind.url;
    }
  }
}
