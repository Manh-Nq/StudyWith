import 'package:flutter/material.dart';

/// Bọc ngoài [MaterialApp] để màn con (ví dụ Cài đặt) đổi [Locale].
class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });
  final Locale locale;
  final ValueChanged<Locale> setLocale;

  static AppLocaleScope of(BuildContext context) {
    final AppLocaleScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found above MaterialApp');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) =>
      oldWidget.locale != locale;
}
