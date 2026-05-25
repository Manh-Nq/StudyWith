import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../model/alphabet_card_view_data.dart';
import '../model/alphabet_override_image_kind.dart';

class AlphabetIllustration extends StatelessWidget {
  const AlphabetIllustration({
    super.key,
    required this.data,
    this.size = 52,
  });
  final AlphabetCardViewData data;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Widget fallback = Icon(
      data.base.icon,
      size: size,
      color: Colors.black87.withValues(alpha: 0.78),
    );
    switch (data.imageKind) {
      case AlphabetOverrideImageKind.icon:
        return fallback;
      case AlphabetOverrideImageKind.url:
        final String url = data.imageValue.trim();
        if (url.isEmpty) {
          return fallback;
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            width: size * 1.4,
            height: size * 1.4,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => fallback,
          ),
        );
      case AlphabetOverrideImageKind.base64:
        final String b64 = data.imageValue.trim();
        if (b64.isEmpty) {
          return fallback;
        }
        try {
          final Uint8List bytes = base64Decode(b64);
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              bytes,
              width: size * 1.4,
              height: size * 1.4,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => fallback,
            ),
          );
        } catch (_) {
          return fallback;
        }
    }
  }
}
