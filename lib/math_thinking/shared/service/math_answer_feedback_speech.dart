import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Phản hồi ngắn khi trả lời đúng / sai (toán tư duy): hiệu ứng âm thanh, không dùng TTS.
///
/// Dùng [AssetSource] + [PlayerMode.lowLatency] trên Android. [BytesSource] không
/// tương thích SoundPool (LOW_LATENCY) trên Android.
class MathAnswerFeedbackSpeech {
  MathAnswerFeedbackSpeech._();
  static final MathAnswerFeedbackSpeech instance =
      MathAnswerFeedbackSpeech._();

  AudioPlayer? _player;
  static bool _globalAudioConfigured = false;

  /// Đường dẫn tương đối trong `pubspec` (`assets/sounds/...`), không gồm `assets/`.
  static const String _correctAsset = 'sounds/math_feedback_correct.wav';
  static const String _wrongAsset = 'sounds/math_feedback_wrong.wav';

  Future<void> _configureGlobalAudioOnce() async {
    if (_globalAudioConfigured || kIsWeb) {
      return;
    }
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.notification,
          ),
        ),
      );
      _globalAudioConfigured = true;
    } catch (_) {}
  }

  Future<void> _ensurePlayer() async {
    if (_player != null) {
      return;
    }
    await _configureGlobalAudioOnce();
    final AudioPlayer p = AudioPlayer();
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await p.setPlayerMode(PlayerMode.lowLatency);
      } catch (_) {}
    }
    await p.setReleaseMode(ReleaseMode.stop);
    await p.setVolume(1.0);
    _player = p;
  }

  /// [languageCode] được giữ trong chữ ký để các màn gọi không đổi; không còn dùng cho TTS.
  Future<void> speakForAnswer(
    bool correct, {
    required String languageCode,
  }) async {
    try {
      await _ensurePlayer();
      final AudioPlayer? p = _player;
      if (p == null) {
        return;
      }
      await p.stop();
      final String asset = correct ? _correctAsset : _wrongAsset;
      await p.play(AssetSource(asset));
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('MathAnswerFeedbackSpeech: $e\n$st');
      }
    }
  }
}
