import 'package:flutter/material.dart';

/// Bảng màu tham chiếu app mầm non (Khan Academy Kids, Moose Math):
/// nền ấm, pastel, accent rõ nhưng không chói.
abstract final class KidFriendlyColors {
  static const Color creamBackground = Color(0xFFFFF8F2);
  static const Color softSurface = Color(0xFFFFFBF8);

  static const Color skyPrimary = Color(0xFF5BA4C9);
  static const Color lavenderPrimary = Color(0xFF7B6FD6);
  static const Color warmCoral = Color(0xFFFF9A7A);
  static const Color sunnyYellow = Color(0xFFFFCA5C);
  static const Color mintGreen = Color(0xFF6BBF8A);

  static const Color onDarkText = Color(0xFFFFFFFF);
  static const Color bodyText = Color(0xFF2D3142);
  static const Color mutedText = Color(0xFF5C6378);

  static const Color success = Color(0xFF5CB87A);
  static const Color successSoft = Color(0xFFE8F7EE);
  static const Color tryAgain = Color(0xFFFF8A80);
  static const Color tryAgainSoft = Color(0xFFFFECEA);

  static const Color readingTint = Color(0xFFE3F4FC);
  static const Color alphabetTint = Color(0xFFFFF0D6);
  static const Color mathTint = Color(0xFFE8F7EE);
  static const Color languageTint = Color(0xFFEDE9FF);

  static const Color mathCountingTint = Color(0xFFD8EEF9);
  static const Color mathOperationsTint = Color(0xFFFFE8D6);
  static const Color mathGeometryTint = Color(0xFFDDF3E6);
  static const Color mathLogicTint = Color(0xFFEDE6FF);

  // —— Dark palette (ấm, không đen tuyền) ——
  static const Color darkScaffold = Color(0xFF1C1D28);
  static const Color darkSurface = Color(0xFF262836);
  static const Color darkBodyText = Color(0xFFE8EAF2);
  static const Color darkMutedText = Color(0xFFA8AEC0);
  static const Color darkSuccessSoft = Color(0xFF1E3A2C);
  static const Color darkTryAgainSoft = Color(0xFF3D2A2A);

  /// Nền Scaffold opaque. Không dùng alpha thấp trên [Scaffold].
  static Color screenBackground(
    Color lightTint, {
    Brightness brightness = Brightness.light,
    double amount = 0.55,
  }) {
    if (brightness == Brightness.dark) {
      return Color.lerp(darkScaffold, _darkVariant(lightTint), amount)!;
    }
    return Color.lerp(creamBackground, lightTint, amount)!;
  }

  static Color barBackground(
    Color lightTint, {
    Brightness brightness = Brightness.light,
  }) {
    if (brightness == Brightness.dark) {
      return _darkVariant(lightTint);
    }
    return lightTint;
  }

  static Color tintSurface(
    Color lightTint, {
    Brightness brightness = Brightness.light,
    double amount = 0.92,
  }) {
    if (brightness == Brightness.dark) {
      return Color.lerp(darkSurface, _darkVariant(lightTint), amount)!;
    }
    return Color.lerp(softSurface, lightTint, amount)!;
  }

  static Color subjectCardBackground(
    Color lightTint, {
    Brightness brightness = Brightness.light,
  }) {
    if (brightness == Brightness.dark) {
      return Color.lerp(darkSurface, _darkVariant(lightTint), 0.72)!;
    }
    return lightTint;
  }

  static Color _darkVariant(Color lightTint) {
    return Color.lerp(darkScaffold, lightTint, 0.32)!;
  }
}
