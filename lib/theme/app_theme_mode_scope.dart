import 'package:flutter/material.dart';

/// Bọc ngoài [MaterialApp] để màn Cài đặt đổi [ThemeMode] (sáng / tối).
class AppThemeModeScope extends InheritedWidget {
  const AppThemeModeScope({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> setThemeMode;

  static AppThemeModeScope of(BuildContext context) {
    final AppThemeModeScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppThemeModeScope>();
    assert(scope != null, 'AppThemeModeScope not found above MaterialApp');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppThemeModeScope oldWidget) =>
      oldWidget.themeMode != themeMode;
}
