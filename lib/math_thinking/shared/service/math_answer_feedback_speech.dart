import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Phản hồi ngắn khi trả lời đúng / sai (toán tư duy): hiệu ứng âm thanh, không dùng TTS.
///
/// Dùng [rootBundle] + [BytesSource] thay cho [AssetSource] để tránh lỗi đường dẫn
/// qua AudioCache và ổn định hơn trên Android/iOS.
class MathAnswerFeedbackSpeech {
  MathAnswerFeedbackSpeech._();
  static final MathAnswerFeedbackSpeech instance =
      MathAnswerFeedbackSpeech._();

  AudioPlayer? _player;
  Uint8List? _correctBytes;
  Uint8List? _wrongBytes;
  static bool _globalAudioConfigured = false;

  static const String _correctKey = 'assets/sounds/math_feedback_correct.wav';
  static const String _wrongKey = 'assets/sounds/math_feedback_wrong.wav';

  Future<void> _ensureBuffers() async {
    if (_correctBytes != null && _wrongBytes != null) {
      return;
    }
    final ByteData correctData = await rootBundle.load(_correctKey);
    final ByteData wrongData = await rootBundle.load(_wrongKey);
    _correctBytes = correctData.buffer.asUint8List();
    _wrongBytes = wrongData.buffer.asUint8List();
  }

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
    await _ensureBuffers();
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
      final Uint8List? correctBuf = _correctBytes;
      final Uint8List? wrongBuf = _wrongBytes;
      if (p == null || correctBuf == null || wrongBuf == null) {
        return;
      }
      await p.stop();
      final Uint8List bytes = correct ? correctBuf : wrongBuf;
      await p.play(
        BytesSource(bytes, mimeType: 'audio/wav'),
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('MathAnswerFeedbackSpeech: $e\n$st');
      }
    }
  }
}
