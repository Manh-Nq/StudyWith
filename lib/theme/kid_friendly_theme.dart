import 'package:flutter/material.dart';

import 'kid_friendly_colors.dart';

/// Kích thước & bo góc thân thiện trẻ nhỏ (Material touch target ≥ 48dp).
/// Dùng chung cho [KidFriendlyTheme.light] và [KidFriendlyTheme.dark].
abstract final class KidFriendlyLayout {
  static const double minTapTarget = 56;
  static const double cardRadius = 20;
  static const double buttonRadius = 16;
  static const double screenPadding = 16;
}

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.tryAgain,
    required this.tryAgainContainer,
    required this.onTryAgain,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color tryAgain;
  final Color tryAgainContainer;
  final Color onTryAgain;

  static const AppSemanticColors light = AppSemanticColors(
    success: KidFriendlyColors.success,
    successContainer: KidFriendlyColors.successSoft,
    onSuccess: Color(0xFF1B5E36),
    tryAgain: KidFriendlyColors.tryAgain,
    tryAgainContainer: KidFriendlyColors.tryAgainSoft,
    onTryAgain: Color(0xFF8B3A34),
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF6BCF96),
    successContainer: KidFriendlyColors.darkSuccessSoft,
    onSuccess: Color(0xFFB8E6C8),
    tryAgain: Color(0xFFFF9E96),
    tryAgainContainer: KidFriendlyColors.darkTryAgainSoft,
    onTryAgain: Color(0xFFFFD0CC),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? tryAgain,
    Color? tryAgainContainer,
    Color? onTryAgain,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      tryAgain: tryAgain ?? this.tryAgain,
      tryAgainContainer: tryAgainContainer ?? this.tryAgainContainer,
      onTryAgain: onTryAgain ?? this.onTryAgain,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) {
      return this;
    }
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      tryAgain: Color.lerp(tryAgain, other.tryAgain, t)!,
      tryAgainContainer:
          Color.lerp(tryAgainContainer, other.tryAgainContainer, t)!,
      onTryAgain: Color.lerp(onTryAgain, other.onTryAgain, t)!,
    );
  }
}

extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors {
    final AppSemanticColors? ext =
        Theme.of(this).extension<AppSemanticColors>();
    if (ext != null) {
      return ext;
    }
    return Theme.of(this).brightness == Brightness.dark
        ? AppSemanticColors.dark
        : AppSemanticColors.light;
  }
}

/// Theme sáng / tối thân thiện trẻ em — cùng [KidFriendlyLayout].
abstract final class KidFriendlyTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        scheme: _lightScheme,
        scaffoldBackground: KidFriendlyColors.creamBackground,
        semantic: AppSemanticColors.light,
        typographyBase: Typography.material2021().black,
        bodyColor: KidFriendlyColors.bodyText,
        appBarBackground: KidFriendlyColors.creamBackground,
        appBarForeground: KidFriendlyColors.bodyText,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        scheme: _darkScheme,
        scaffoldBackground: KidFriendlyColors.darkScaffold,
        semantic: AppSemanticColors.dark,
        typographyBase: Typography.material2021().white,
        bodyColor: KidFriendlyColors.darkBodyText,
        appBarBackground: KidFriendlyColors.darkScaffold,
        appBarForeground: KidFriendlyColors.darkBodyText,
      );

  static const ColorScheme _lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: KidFriendlyColors.lavenderPrimary,
      onPrimary: KidFriendlyColors.onDarkText,
      primaryContainer: Color(0xFFE8E4FF),
      onPrimaryContainer: Color(0xFF3D3568),
      secondary: KidFriendlyColors.warmCoral,
      onSecondary: KidFriendlyColors.onDarkText,
      secondaryContainer: Color(0xFFFFE5DC),
      onSecondaryContainer: Color(0xFF6B3D2E),
      tertiary: KidFriendlyColors.mintGreen,
      onTertiary: KidFriendlyColors.onDarkText,
      tertiaryContainer: Color(0xFFD8F3E4),
      onTertiaryContainer: Color(0xFF1F4D35),
      error: KidFriendlyColors.tryAgain,
      onError: KidFriendlyColors.onDarkText,
      errorContainer: KidFriendlyColors.tryAgainSoft,
      onErrorContainer: Color(0xFF8B3A34),
      surface: KidFriendlyColors.softSurface,
      onSurface: KidFriendlyColors.bodyText,
      onSurfaceVariant: KidFriendlyColors.mutedText,
      outline: Color(0xFFC8CDD8),
      outlineVariant: Color(0xFFE2E6EF),
      shadow: Color(0x1A2D3142),
      surfaceContainerLowest: KidFriendlyColors.creamBackground,
      surfaceContainerLow: Color(0xFFF5F0FF),
      surfaceContainer: Color(0xFFEFEAF8),
      surfaceContainerHigh: Color(0xFFE8E4F0),
      surfaceContainerHighest: Color(0xFFE2DEE8),
    );

  static const ColorScheme _darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF9B91E8),
      onPrimary: KidFriendlyColors.onDarkText,
      primaryContainer: Color(0xFF3D3568),
      onPrimaryContainer: Color(0xFFE8E4FF),
      secondary: Color(0xFFFFB09A),
      onSecondary: Color(0xFF3D2520),
      secondaryContainer: Color(0xFF5C3D32),
      onSecondaryContainer: Color(0xFFFFE5DC),
      tertiary: Color(0xFF7BCF9A),
      onTertiary: Color(0xFF1A3328),
      tertiaryContainer: Color(0xFF2A4D38),
      onTertiaryContainer: Color(0xFFD8F3E4),
      error: Color(0xFFFF9E96),
      onError: KidFriendlyColors.onDarkText,
      errorContainer: KidFriendlyColors.darkTryAgainSoft,
      onErrorContainer: Color(0xFFFFD0CC),
      surface: KidFriendlyColors.darkSurface,
      onSurface: KidFriendlyColors.darkBodyText,
      onSurfaceVariant: KidFriendlyColors.darkMutedText,
      outline: Color(0xFF4A5068),
      outlineVariant: Color(0xFF353848),
      shadow: Color(0x66000000),
      surfaceContainerLowest: KidFriendlyColors.darkScaffold,
      surfaceContainerLow: Color(0xFF222330),
      surfaceContainer: Color(0xFF2A2C3A),
      surfaceContainerHigh: Color(0xFF323448),
      surfaceContainerHighest: Color(0xFF3A3D50),
    );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required AppSemanticColors semantic,
    required TextTheme typographyBase,
    required Color bodyColor,
    required Color appBarBackground,
    required Color appBarForeground,
  }) {
    final TextTheme textTheme = typographyBase.apply(
          bodyColor: bodyColor,
          displayColor: bodyColor,
        );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      extensions: <ThemeExtension<dynamic>>[
        semantic,
      ],
      textTheme: textTheme.copyWith(
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 17,
          height: 1.35,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          height: 1.35,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: appBarForeground,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius + 4),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KidFriendlyLayout.buttonRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, KidFriendlyLayout.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(KidFriendlyLayout.buttonRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, KidFriendlyLayout.minTapTarget),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(KidFriendlyLayout.buttonRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KidFriendlyLayout.buttonRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
        thickness: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
    );
  }
}
