import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class ReadingTtsService {
  ReadingTtsService._(this._tts);

  final FlutterTts _tts;

  factory ReadingTtsService.create() {
    return ReadingTtsService._(FlutterTts());
  }

  Future<void> awaitSpeakCompletion(bool value) {
    return _tts.awaitSpeakCompletion(value);
  }

  Future<void> setSharedInstance(bool shared) {
    return _tts.setSharedInstance(shared);
  }

  Future<void> setLanguage(String locale) {
    return _tts.setLanguage(locale);
  }

  Future<dynamic> getVoices() {
    return _tts.getVoices;
  }

  Future<void> setVoice(Map<String, String> voice) {
    return _tts.setVoice(voice);
  }

  Future<void> setSpeechRate(double rate) {
    return _tts.setSpeechRate(rate);
  }

  Future<void> stop() {
    return _tts.stop();
  }

  Future<void> speak(String text) {
    return _tts.speak(text);
  }

  Future<void> dispose() async {
    await _tts.stop();
  }

  static Future<void> configureSpeechRateForPlatform({
    required ReadingTtsService service,
    required double normalizedSlider,
  }) async {
    final double clamped = normalizedSlider.clamp(0.0, 1.0);
    if (Platform.isIOS) {
      final double rate = 0.28 + clamped * 0.62;
      await service.setSpeechRate(rate);
    } else {
      final double rate = 0.35 + clamped * 0.95;
      await service.setSpeechRate(rate);
    }
  }
}
