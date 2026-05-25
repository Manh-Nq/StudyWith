import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../model/math_entity_type.dart';

class MathEntityImageWidget extends StatelessWidget {
  const MathEntityImageWidget({
    super.key,
    required this.entity,
    required this.size,
  });
  final MathEntityType entity;
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (entity.imageKind) {
      case MathEntityImageKind.vector:
        return _buildVectorShape(context, entity.imageValue, size);
      case MathEntityImageKind.base64:
        return _buildBase64Image(context, entity.imageValue, size);
      case MathEntityImageKind.url:
        return _buildNetworkImage(context, entity.imageValue, size);
    }
  }

  Widget _buildBase64Image(
      BuildContext context, String base64Value, double size) {
    try {
      final Uint8List bytes = base64Decode(base64Value);
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return _fallbackBox(context, size);
          },
        ),
      );
    } catch (_) {
      return _fallbackBox(context, size);
    }
  }

  Widget _buildNetworkImage(
      BuildContext context, String imageUrl, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return _fallbackBox(context, size);
        },
      ),
    );
  }

  Widget _buildVectorShape(BuildContext context, String shape, double size) {
    final Color fill = Theme.of(context).colorScheme.primary;
    switch (shape) {
      case 'circle':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: fill),
        );
      case 'square':
        return Container(
          width: size,
          height: size,
          color: fill,
        );
      case 'rectangle':
        return Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Container(
            width: size,
            height: size * 0.62,
            color: fill,
          ),
        );
      case 'triangle':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _TrianglePainter(color: fill),
          ),
        );
      case 'star':
        return SizedBox(
          width: size,
          height: size,
          child: Icon(Icons.star_rounded, size: size, color: fill),
        );
      default:
        return _fallbackBox(context, size);
    }
  }

  Widget _fallbackBox(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image_not_supported_rounded),
    );
  }
}

/// Tam giác đều (đỉnh trên, đáy nằm ngang), ba góc nhọn — không bo góc.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset apex = Offset(w / 2, 0);
    final Offset bottomRight = Offset(w, h);
    final Offset bottomLeft = Offset(0, h);
    final Path path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
