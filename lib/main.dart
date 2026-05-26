import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/home/home_screen.dart';
import 'package:location_app/locale/app_locale_scope.dart';
import 'package:location_app/theme/app_theme_mode_scope.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsThemeModeKey = 'app_theme_mode';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('vi');
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPreferences());
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String code = prefs.getString('app_locale') ?? 'vi';
    final String themeCode = prefs.getString(_prefsThemeModeKey) ?? 'light';
    if (!mounted) {
      return;
    }
    setState(() {
      _locale = Locale(code);
      _themeMode = _themeModeFromStorage(themeCode);
    });
  }

  ThemeMode _themeModeFromStorage(String code) {
    switch (code) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  void _setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
    unawaited(
      SharedPreferences.getInstance().then(
        (SharedPreferences p) => p.setString('app_locale', value.languageCode),
      ),
    );
  }

  void _setThemeMode(ThemeMode value) {
    setState(() {
      _themeMode = value;
    });
    final String code = value == ThemeMode.dark ? 'dark' : 'light';
    unawaited(
      SharedPreferences.getInstance().then(
        (SharedPreferences p) => p.setString(_prefsThemeModeKey, code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      locale: _locale,
      setLocale: _setLocale,
      child: AppThemeModeScope(
        themeMode: _themeMode,
        setThemeMode: _setThemeMode,
        child: MaterialApp(
          locale: _locale,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: KidFriendlyTheme.light(),
          darkTheme: KidFriendlyTheme.dark(),
          themeMode: _themeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

