import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Đọc từ tiếng Anh (flutter_tts) — tốc độ lưu trong SharedPreferences.
class LanguageStudyTtsService {
  LanguageStudyTtsService._();
  static final LanguageStudyTtsService instance = LanguageStudyTtsService._();

  static const String _prefsSpeedKey = 'language_study_tts_speed_slider';

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  double _speedSlider = 0.5;

  double get speedSlider => _speedSlider;

  Future<void> ensureReady() async {
    if (_ready) {
      return;
    }
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('en-US');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _speedSlider = prefs.getDouble(_prefsSpeedKey) ?? 0.5;
    await _applySpeechRate();
    _ready = true;
  }

  Future<void> setSpeedSlider(double value) async {
    _speedSlider = value.clamp(0.0, 1.0);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefsSpeedKey, _speedSlider);
    await _applySpeechRate();
  }

  Future<void> _applySpeechRate() async {
    final double clamped = _speedSlider.clamp(0.0, 1.0);
    if (Platform.isIOS) {
      await _tts.setSpeechRate(0.28 + clamped * 0.62);
    } else {
      await _tts.setSpeechRate(0.35 + clamped * 0.95);
    }
  }

  Future<void> speakEnglish(String word) async {
    await ensureReady();
    final String text = word.trim();
    if (text.isEmpty) {
      return;
    }
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
