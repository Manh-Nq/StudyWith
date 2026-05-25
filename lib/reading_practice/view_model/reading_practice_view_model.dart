import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/reading_practice_ui_event.dart';
import '../model/reading_unit.dart';
import '../service/reading_segment_builder.dart';
import '../service/reading_token_bounds.dart';
import '../service/reading_tts_service.dart';

class ReadingPracticeViewModel extends ChangeNotifier {
  ReadingPracticeViewModel({
    ReadingTtsService? ttsService,
    this.onCompletedFullReadingPass,
  }) : _tts = ttsService ?? ReadingTtsService.create();

  final ReadingTtsService _tts;
  final void Function()? onCompletedFullReadingPass;
  final StreamController<ReadingPracticeUiEvent> _uiEventsController =
      StreamController<ReadingPracticeUiEvent>.broadcast();

  bool _disposed = false;
  String _appliedText = '';
  List<ReadingUnit> _units = <ReadingUnit>[];
  List<ReadingUnit>? _savedUnitsBeforeSnippet;
  bool _snippetPlaybackActive = false;
  double _speedNormalized = 0.45;
  int _highlightStart = -1;
  int _highlightEnd = -1;
  int _startUnitIndex = 0;
  bool _ttsReady = false;

  bool _sessionActive = false;
  bool _paused = false;
  bool _stopRequested = false;
  int _currentUnitIndex = 0;
  String _largeFocusCaption = '';
  bool _ttsUtteranceInProgress = false;
  bool _replaySameUnitAfterResume = false;
  List<Map<String, String>> _availableVietnameseVoices =
      <Map<String, String>>[];
  Map<String, String>? _selectedVoice;

  /// Hoàn tất khi một lần chạy `play()` kết thúc (kể cả `finally`). Tránh race với `stopPlayback` / đánh vần đoạn.
  Completer<void>? _playbackIdleGate;

  /// Đoạn [UTF-16] vừa đánh vần (chạm từ / menu); dùng cho nút Phát lại.
  int _lastSpellSnippetStart = -1;
  int _lastSpellSnippetEnd = -1;

  Stream<ReadingPracticeUiEvent> get uiEvents => _uiEventsController.stream;

  String get appliedText => _appliedText;

  List<ReadingUnit> get units => List<ReadingUnit>.unmodifiable(_units);

  double get speedNormalized => _speedNormalized;

  int get highlightStart => _highlightStart;

  int get highlightEnd => _highlightEnd;

  /// Phiên đọc đang mở (đang phát hoặc đã tạm dừng).
  bool get sessionActive => _sessionActive;

  bool get paused => _paused && _sessionActive;

  /// Đang phát (không tạm dừng).
  bool get speakingActive => _sessionActive && !_paused;

  bool get ttsReady => _ttsReady;

  bool get canPlay => _ttsInitFinished && _units.isNotEmpty && !_sessionActive;

  bool get canPause => _sessionActive && !_paused;

  bool get canResume => _sessionActive && _paused;

  int get currentUnitIndex => _currentUnitIndex;

  String get largeFocusCaption => _largeFocusCaption;

  bool get canReplayLastSpell {
    if (_lastSpellSnippetStart < 0 ||
        _lastSpellSnippetEnd <= _lastSpellSnippetStart) {
      return false;
    }
    if (_lastSpellSnippetEnd > _appliedText.length) {
      return false;
    }
    return ReadingSegmentBuilder.containsLetter(
      _appliedText.substring(_lastSpellSnippetStart, _lastSpellSnippetEnd),
    );
  }

  List<Map<String, String>> get availableVietnameseVoices =>
      List<Map<String, String>>.unmodifiable(_availableVietnameseVoices);

  Map<String, String>? get selectedVoice => _selectedVoice;

  /// Hiển thị ô chữ lớn theo **từ** (token) tại vị trí chạm, không cần mở đánh vần.
  void previewTokenAtTextOffset(int utf16Offset) {
    if (_appliedText.isEmpty) {
      return;
    }
    final int o = utf16Offset.clamp(0, _appliedText.length);
    final ({int start, int end})? r =
        ReadingTokenBounds.tokenRangeContaining(_appliedText, o);
    if (r == null) {
      _largeFocusCaption = '';
    } else {
      _largeFocusCaption = _appliedText.substring(r.start, r.end);
    }
    _notifySafe();
  }

  bool _ttsInitFinished = false;

  Future<void> initialize() async {
    try {
      await _tts.awaitSpeakCompletion(true);
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
      }
      await _tts.setLanguage('vi-VN');
      await _loadVoices();
      await _applySelectedVoice();
      await ReadingTtsService.configureSpeechRateForPlatform(
        service: _tts,
        normalizedSlider: _speedNormalized,
      );
      _ttsReady = true;
    } catch (e, st) {
      debugPrint('ReadingPracticeViewModel.initialize failed: $e\n$st');
      _ttsReady = false;
      if (e is MissingPluginException) {
        _emitSnackBar(
          'flutter_tts chưa được nhúng vào bản build đang chạy (MissingPluginException). '
          'Hãy thoát app hoàn toàn, chạy: flutter clean && flutter pub get. '
          'iOS: cd ios && pod install. '
          'Sau đó flutter run — bắt buộc build lại, không chỉ Hot Reload.',
        );
      } else {
        _emitSnackBar(
          'Không cấu hình được giọng đọc: $e. '
          'Kiểm tra Cài đặt → Ngôn ngữ / giọng TTS Tiếng Việt.',
        );
      }
    } finally {
      if (!_disposed) {
        _ttsInitFinished = true;
        _notifySafe();
      }
    }
  }

  void applyScript(String rawText) {
    _stopRequested = true;
    _paused = false;
    _sessionActive = false;
    unawaited(_tts.stop());
    _snippetPlaybackActive = false;
    _savedUnitsBeforeSnippet = null;
    _appliedText = rawText;
    _units = ReadingSegmentBuilder.build(rawText);
    _highlightStart = -1;
    _highlightEnd = -1;
    _startUnitIndex = 0;
    _largeFocusCaption = '';
    _lastSpellSnippetStart = -1;
    _lastSpellSnippetEnd = -1;
    if (_units.isEmpty && rawText.trim().isNotEmpty) {
      _emitSnackBar(
        'Không có từ/chữ nào để đọc (toàn khoảng trắng hoặc ký tự đặc biệt). '
        'Thử gõ hoặc dán văn có chữ cái.',
      );
    }
    _notifySafe();
  }

  void setSpeedNormalized(double value) {
    final double v = value.clamp(0.0, 1.0);
    if ((_speedNormalized - v).abs() < 0.001) {
      return;
    }
    _speedNormalized = v;
    _notifySafe();
  }

  Future<void> setSelectedVoice(Map<String, String>? voice) async {
    if (_sessionActive) {
      _emitSnackBar('Tạm không đổi giọng khi đang đọc.');
      return;
    }
    if (_voiceEquals(_selectedVoice, voice)) {
      return;
    }
    _selectedVoice = voice;
    if (_ttsReady) {
      try {
        await _applySelectedVoice();
      } catch (e) {
        _emitSnackBar('Không đổi được giọng đọc: $e');
      }
    }
    _notifySafe();
  }

  /// Đánh vần chỉ đoạn được chọn/bôi đen; map offset về toàn bài để karaoke trên văn gốc.
  Future<void> startSpellSnippetForRange(int selStart, int selEnd) async {
    if (_appliedText.isEmpty) {
      return;
    }
    final int a = selStart.clamp(0, _appliedText.length);
    final int b = selEnd.clamp(a, _appliedText.length);
    final String snippet = _appliedText.substring(a, b);
    if (!ReadingSegmentBuilder.containsLetter(snippet)) {
      _emitSnackBar('Chọn đoạn có chữ để đánh vần.');
      return;
    }
    _lastSpellSnippetStart = a;
    _lastSpellSnippetEnd = b;
    await stopPlayback();
    if (!_snippetPlaybackActive) {
      _savedUnitsBeforeSnippet = List<ReadingUnit>.from(_units);
    }
    _snippetPlaybackActive = true;
    final List<ReadingUnit> raw = ReadingSegmentBuilder.build(snippet);
    _units = raw
        .map(
          (ReadingUnit u) => ReadingUnit(
            start: a + u.start,
            end: a + u.end,
            speakText: u.speakText,
          ),
        )
        .toList();
    _startUnitIndex = 0;
    _highlightStart = -1;
    _highlightEnd = -1;
    final ({int start, int end})? firstTok =
        ReadingTokenBounds.tokenRangeContaining(_appliedText, a);
    _largeFocusCaption = firstTok != null
        ? _appliedText.substring(firstTok.start, firstTok.end)
        : snippet.trim();
    _notifySafe();
    await play();
    if (_disposed || _appliedText.isEmpty) {
      return;
    }
    _highlightStart = a;
    _highlightEnd = b;
    _largeFocusCaption = _appliedText.substring(a, b);
    _notifySafe();
  }

  Future<void> play() async {
    if (!_ttsInitFinished || _units.isEmpty || _sessionActive) {
      return;
    }
    if (!_ttsReady) {
      try {
        await _tts.awaitSpeakCompletion(true);
        if (Platform.isIOS) {
          await _tts.setSharedInstance(true);
        }
        await _tts.setLanguage('vi-VN');
        await _loadVoices();
        await _applySelectedVoice();
        await ReadingTtsService.configureSpeechRateForPlatform(
          service: _tts,
          normalizedSlider: _speedNormalized,
        );
        _ttsReady = true;
      } catch (e, st) {
        debugPrint('ReadingPracticeViewModel.play retry init failed: $e\n$st');
        if (e is MissingPluginException) {
          _emitSnackBar(
            'flutter_tts chưa nhúng native — thoát app, flutter clean && flutter pub get, '
            'iOS: cd ios && pod install, rồi flutter run (không Hot Reload).',
          );
        } else {
          _emitSnackBar('Giọng đọc chưa sẵn sàng: $e');
        }
        return;
      }
    }
    final Completer<void> idleGate = Completer<void>();
    _playbackIdleGate = idleGate;
    _stopRequested = false;
    _paused = false;
    _sessionActive = true;
    try {
      await _tts.stop();
      await ReadingTtsService.configureSpeechRateForPlatform(
        service: _tts,
        normalizedSlider: _speedNormalized,
      );
      try {
        int i = _startUnitIndex.clamp(0, _units.length - 1);
        while (i < _units.length) {
          if (_stopRequested || _disposed) {
            break;
          }
          while (_paused && !_stopRequested && !_disposed) {
            await Future<void>.delayed(const Duration(milliseconds: 40));
          }
          if (_stopRequested || _disposed) {
            break;
          }
          final ReadingUnit u = _units[i];
          _currentUnitIndex = i;
          _highlightStart = u.start;
          _highlightEnd = u.end;
          _largeFocusCaption = _appliedText.substring(u.start, u.end);
          _notifySafe();
          _ttsUtteranceInProgress = true;
          try {
            await _tts.speak(u.speakText);
          } finally {
            _ttsUtteranceInProgress = false;
          }
          if (_stopRequested || _disposed) {
            break;
          }
          while (_paused && !_stopRequested && !_disposed) {
            await Future<void>.delayed(const Duration(milliseconds: 40));
          }
          if (_stopRequested || _disposed) {
            break;
          }
          if (_replaySameUnitAfterResume) {
            _replaySameUnitAfterResume = false;
            continue;
          }
          await Future<void>.delayed(Duration(milliseconds: _pauseMillis()));
          i++;
        }
        final bool fullPass = !_stopRequested &&
            !_disposed &&
            _units.isNotEmpty &&
            i >= _units.length;
        if (fullPass) {
          final void Function()? cb = onCompletedFullReadingPass;
          if (cb != null) {
            cb();
          }
        }
      } finally {
        if (!_disposed) {
          _sessionActive = false;
          _paused = false;
          _stopRequested = false;
          _replaySameUnitAfterResume = false;
          _ttsUtteranceInProgress = false;
          _restoreSnippetIfNeeded();
          _highlightStart = -1;
          _highlightEnd = -1;
        }
      }
    } finally {
      if (!idleGate.isCompleted) {
        idleGate.complete();
      }
      if (identical(_playbackIdleGate, idleGate)) {
        _playbackIdleGate = null;
      }
      if (!_disposed) {
        _notifySafe();
      }
    }
  }

  Future<void> pausePlayback() async {
    if (!_sessionActive || _paused) {
      return;
    }
    _paused = true;
    if (_ttsUtteranceInProgress) {
      _replaySameUnitAfterResume = true;
    }
    await _tts.stop();
    _notifySafe();
  }

  Future<void> resumePlayback() async {
    if (!_sessionActive || !_paused) {
      return;
    }
    _paused = false;
    _notifySafe();
  }

  /// Phát lại đúng đoạn vừa đánh vần (chạm từ / chọn đoạn).
  Future<void> replayLastSpelledWord() async {
    if (!canReplayLastSpell) {
      return;
    }
    await startSpellSnippetForRange(
        _lastSpellSnippetStart, _lastSpellSnippetEnd);
  }

  Future<void> stopPlayback() async {
    _stopRequested = true;
    _paused = false;
    final Completer<void>? idle = _playbackIdleGate;
    await _tts.stop();
    if (idle != null) {
      await idle.future;
    }
    if (_disposed) {
      return;
    }
    _sessionActive = false;
    _highlightStart = -1;
    _highlightEnd = -1;
    _restoreSnippetIfNeeded();
    _notifySafe();
  }

  void _restoreSnippetIfNeeded() {
    if (!_snippetPlaybackActive) {
      return;
    }
    _snippetPlaybackActive = false;
    if (_savedUnitsBeforeSnippet != null) {
      _units = List<ReadingUnit>.from(_savedUnitsBeforeSnippet!);
      _savedUnitsBeforeSnippet = null;
    } else if (_appliedText.isNotEmpty) {
      _units = ReadingSegmentBuilder.build(_appliedText);
    }
  }

  int _pauseMillis() {
    final double inverse = 1.0 - _speedNormalized.clamp(0.0, 1.0);
    return (80 + inverse * 420).round();
  }

  void _emitSnackBar(String message) {
    if (_disposed || _uiEventsController.isClosed) {
      return;
    }
    _uiEventsController.add(ReadingPracticeSnackRequested(message));
  }

  Future<void> _loadVoices() async {
    final dynamic raw = await _tts.getVoices();
    final List<Map<String, String>> parsed = <Map<String, String>>[];
    if (raw is List<dynamic>) {
      for (final dynamic item in raw) {
        if (item is Map<dynamic, dynamic>) {
          final String? locale =
              _asString(item['locale']) ?? _asString(item['language']);
          final String? name = _asString(item['name']);
          if (locale == null || name == null) {
            continue;
          }
          if (!locale.toLowerCase().startsWith('vi')) {
            continue;
          }
          parsed.add(<String, String>{'name': name, 'locale': locale});
        }
      }
    }
    parsed.sort((Map<String, String> a, Map<String, String> b) {
      final String localeA = a['locale'] ?? '';
      final String localeB = b['locale'] ?? '';
      final int localeCompare = localeA.compareTo(localeB);
      if (localeCompare != 0) {
        return localeCompare;
      }
      final String nameA = a['name'] ?? '';
      final String nameB = b['name'] ?? '';
      return nameA.compareTo(nameB);
    });
    _availableVietnameseVoices = parsed;
    if (_selectedVoice != null) {
      final bool stillExists = _availableVietnameseVoices.any(
        (Map<String, String> voice) => _voiceEquals(voice, _selectedVoice),
      );
      if (!stillExists) {
        _selectedVoice = null;
      }
    }
  }

  Future<void> _applySelectedVoice() async {
    if (_selectedVoice == null) {
      return;
    }
    await _tts.setLanguage(_selectedVoice!['locale'] ?? 'vi-VN');
    await _tts.setVoice(_selectedVoice!);
  }

  bool _voiceEquals(Map<String, String>? a, Map<String, String>? b) {
    if (a == null || b == null) {
      return a == b;
    }
    return (a['name'] ?? '') == (b['name'] ?? '') &&
        (a['locale'] ?? '') == (b['locale'] ?? '');
  }

  String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  void _notifySafe() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_tts.dispose());
    _uiEventsController.close();
    super.dispose();
  }
}
