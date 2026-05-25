import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:location_app/study_tracking/study_session_recorder.dart';
import 'package:location_app/study_tracking/study_subject_keys.dart';

import '../model/reading_practice_ui_event.dart';
import '../service/reading_token_bounds.dart';
import '../service/vietnamese_educational_spelling.dart';
import '../view_model/reading_practice_view_model.dart';
import 'reading_highlight_span_builder.dart';
import 'reading_lyrics_scroll_helper.dart';

/// Giao diện cỡ lớn, nút to — phù hợp trẻ nhỏ (đánh vần SGK).
class ReadingPracticeScreen extends StatefulWidget {
  const ReadingPracticeScreen({super.key});

  @override
  State<ReadingPracticeScreen> createState() => _ReadingPracticeScreenState();
}

class _ReadingPracticeScreenState extends State<ReadingPracticeScreen> {
  static const double _kidTapMin = 52;
  static const double _bodyRadius = 20;
  static const double _lyricsFontSize = 34;
  static const double _focusWordSize = 40;

  late final ReadingPracticeViewModel _viewModel = ReadingPracticeViewModel(
    onCompletedFullReadingPass: () {
      StudySessionRecorder.instance.recordReadingPassCompleted();
    },
  );
  late final TextEditingController _draftController = TextEditingController();
  late final ScrollController _lyricsScrollController = ScrollController();
  final GlobalKey _paragraphKey = GlobalKey();
  StreamSubscription<ReadingPracticeUiEvent>? _uiSubscription;
  int _lastHighlightSignature = -999999;
  Offset? _lyricsPtrDown;
  DateTime? _lyricsPtrDownTime;
  bool _screenLocked = false;
  String _screenLockPassword = '';

  @override
  void initState() {
    super.initState();
    unawaited(
      StudySessionRecorder.instance.enterSubject(StudySubjectKeys.reading),
    );
    _uiSubscription = _viewModel.uiEvents.listen(_onUiEvent);
    _viewModel.addListener(_onViewModelChanged);
    unawaited(_viewModel.initialize());
  }

  void _onUiEvent(ReadingPracticeUiEvent event) {
    if (!mounted) {
      return;
    }
    switch (event) {
      case ReadingPracticeSnackRequested(:final String message):
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(fontSize: 18)),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _onViewModelChanged() {
    setState(() {});
    _scheduleLyricsScrollIfNeeded();
  }

  void _scheduleLyricsScrollIfNeeded() {
    final int start = _viewModel.highlightStart;
    final int end = _viewModel.highlightEnd;
    final int sig = start * 100000 + end;
    if (sig == _lastHighlightSignature) {
      return;
    }
    _lastHighlightSignature = sig;
    if (start < 0) {
      return;
    }
    ReadingLyricsScrollHelper.scrollHighlightIntoView(
      scrollController: _lyricsScrollController,
      paragraphKey: _paragraphKey,
      highlightStart: start,
      highlightEnd: end,
    );
  }

  TextStyle _baseLyricsStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextStyle(
      fontSize: _lyricsFontSize,
      height: 1.75,
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );
  }

  void _clearAll() {
    _draftController.clear();
    _viewModel.applyScript('');
    setState(() {});
  }

  Future<void> _pasteFromClipboardAndRevealEditor() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    final String? text = data?.text;
    if (text == null || text.isEmpty) {
      return;
    }
    _draftController.text = text;
    _draftController.selection = TextSelection.collapsed(offset: text.length);
    if (_viewModel.appliedText.trim().isNotEmpty) {
      _viewModel.applyScript('');
    }
    setState(() {});
  }

  Future<void> _showSpeedDialog(BuildContext context) async {
    final ReadingPracticeViewModel vm = _viewModel;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Tốc độ đọc'),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setLocal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Chậm',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12),
                          ),
                          child: Slider(
                            value: vm.speedNormalized,
                            onChanged: vm.sessionActive
                                ? null
                                : (double v) {
                                    vm.setSpeedNormalized(v);
                                    setLocal(() {});
                                  },
                          ),
                        ),
                      ),
                      Text(
                        'Nhanh',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  if (vm.sessionActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Tạm không đổi tốc độ khi đang đọc.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  String _voiceLabel(Map<String, String> voice) {
    final String name = voice['name'] ?? 'Voice';
    final String locale = voice['locale'] ?? '';
    if (locale.isEmpty) {
      return name;
    }
    return '$name ($locale)';
  }

  Future<void> _showVoiceDialog(BuildContext context) async {
    final ReadingPracticeViewModel vm = _viewModel;
    if (vm.sessionActive) {
      _onUiEvent(const ReadingPracticeSnackRequested(
          'Tạm không đổi giọng khi đang đọc.'));
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        Map<String, String>? selected = vm.selectedVoice;
        final List<Map<String, String>> voices = vm.availableVietnameseVoices;
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setLocal) {
            return AlertDialog(
              title: const Text('Chọn giọng đọc'),
              content: SizedBox(
                width: 420,
                child: voices.isEmpty
                    ? const Text(
                        'Thiết bị chưa cung cấp giọng Tiếng Việt. Sẽ dùng giọng mặc định.')
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RadioListTile<Map<String, String>?>(
                              value: null,
                              groupValue: selected,
                              onChanged: (Map<String, String>? value) {
                                setLocal(() {
                                  selected = value;
                                });
                              },
                              title: const Text('Mặc định hệ thống'),
                              contentPadding: EdgeInsets.zero,
                            ),
                            ...voices.map(
                              (Map<String, String> voice) =>
                                  RadioListTile<Map<String, String>?>(
                                value: voice,
                                groupValue: selected,
                                onChanged: (Map<String, String>? value) {
                                  setLocal(() {
                                    selected = value;
                                  });
                                },
                                title: Text(_voiceLabel(voice)),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Huỷ'),
                ),
                FilledButton(
                  onPressed: () async {
                    await vm.setSelectedVoice(selected);
                    if (!mounted) {
                      return;
                    }
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Chọn'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmExitAndBack() async {
    if (_screenLocked) {
      _showLockedHint();
      return;
    }
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thoát bài đọc?'),
          content: const Text('Bạn có chắc muốn quay lại không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Ở lại'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Thoát'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }
    await _viewModel.stopPlayback();
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  void _showLockedHint() {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Màn hình đang khoá. Bấm nút Mở khoá để nhập mật khẩu.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleScreenLock() async {
    if (_screenLocked) {
      final bool unlocked = await _showUnlockPasswordDialog();
      if (!mounted || !unlocked) {
        return;
      }
      setState(() {
        _screenLocked = false;
        _screenLockPassword = '';
      });
      return;
    }
    final String? password = await _showSetPasswordDialog();
    if (!mounted || password == null) {
      return;
    }
    setState(() {
      _screenLockPassword = password;
      _screenLocked = true;
    });
    _showLockedHint();
  }

  Future<String?> _showSetPasswordDialog() async {
    final String? password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        String input = '';
        return AlertDialog(
          title: const Text('Khoá màn hình học'),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setLocalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text('Nhập mật khẩu để khoá màn hình.'),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mật khẩu',
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (String value) {
                      setLocalState(() {
                        input = value;
                      });
                    },
                    onSubmitted: (String value) {
                      final String trimmed = value.trim();
                      if (trimmed.isNotEmpty) {
                        Navigator.of(dialogContext).pop(trimmed);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () {
                final String trimmed = input.trim();
                if (trimmed.isEmpty) {
                  return;
                }
                Navigator.of(dialogContext).pop(trimmed);
              },
              child: const Text('Khoá'),
            ),
          ],
        );
      },
    );
    return password;
  }

  Future<bool> _showUnlockPasswordDialog() async {
    final String? password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        String input = '';
        return AlertDialog(
          title: const Text('Mở khoá'),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setLocalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text('Nhập mật khẩu để mở khoá màn hình.'),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Mật khẩu',
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (String value) {
                      setLocalState(() {
                        input = value;
                      });
                    },
                    onSubmitted: (String value) {
                      final String trimmed = value.trim();
                      if (trimmed.isNotEmpty) {
                        Navigator.of(dialogContext).pop(trimmed);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () {
                final String trimmed = input.trim();
                if (trimmed.isEmpty) {
                  return;
                }
                Navigator.of(dialogContext).pop(trimmed);
              },
              child: const Text('Mở khoá'),
            ),
          ],
        );
      },
    );
    if (!mounted || password == null) {
      return false;
    }
    final bool matched = password == _screenLockPassword;
    if (!matched) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai mật khẩu, vui lòng thử lại.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return matched;
  }

  Future<bool> _onWillPop() async {
    if (_screenLocked) {
      _showLockedHint();
      return false;
    }
    await _confirmExitAndBack();
    return false;
  }

  Future<void> _replayFocusOrLastSpell() async {
    if (_viewModel.canReplayLastSpell) {
      await _viewModel.replayLastSpelledWord();
      return;
    }
    final int start = _viewModel.highlightStart;
    final int end = _viewModel.highlightEnd;
    if (start >= 0 && end > start) {
      await _viewModel.startSpellSnippetForRange(start, end);
      return;
    }
    _showLockedHint();
  }

  RenderEditable? _findRenderEditable(RenderObject? root) {
    RenderEditable? hit;
    void visit(RenderObject? node) {
      if (node == null || hit != null) {
        return;
      }
      if (node is RenderEditable) {
        hit = node;
        return;
      }
      node.visitChildren(visit);
    }

    visit(root);
    return hit;
  }

  int? _utf16OffsetAtLyricsGlobal(Offset globalPosition) {
    final BuildContext? ctx = _paragraphKey.currentContext;
    if (ctx == null) {
      return null;
    }
    final RenderEditable? ed = _findRenderEditable(ctx.findRenderObject());
    if (ed == null) {
      return null;
    }
    final String full = _viewModel.appliedText;
    if (full.isEmpty) {
      return null;
    }
    final Offset local = ed.globalToLocal(globalPosition);
    final TextPainter painter = TextPainter(
      text: TextSpan(
        style: _baseLyricsStyle(context),
        text: full,
      ),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.maybeLocaleOf(context),
    )..layout(maxWidth: ed.size.width);
    return painter.getPositionForOffset(local).offset.clamp(0, full.length);
  }

  Future<void> _playWordAtLyricsGlobal(Offset globalPosition) async {
    final String full = _viewModel.appliedText;
    if (full.isEmpty || !mounted) {
      return;
    }
    final int? offset = _utf16OffsetAtLyricsGlobal(globalPosition);
    if (offset == null) {
      return;
    }
    final ({int start, int end})? r =
        ReadingTokenBounds.tokenRangeContaining(full, offset);
    if (r == null) {
      return;
    }
    await _viewModel.startSpellSnippetForRange(r.start, r.end);
  }

  void _lyricsPointerDown(PointerDownEvent event) {
    _lyricsPtrDown = event.position;
    _lyricsPtrDownTime = DateTime.now();
  }

  void _lyricsPointerMove(PointerMoveEvent event) {
    final Offset? down = _lyricsPtrDown;
    if (down == null) {
      return;
    }
    if ((event.position - down).distance > 28) {
      _lyricsPtrDown = null;
    }
  }

  void _lyricsPointerUp(PointerUpEvent event) {
    final Offset? down = _lyricsPtrDown;
    final DateTime? downTime = _lyricsPtrDownTime;
    _lyricsPtrDown = null;
    _lyricsPtrDownTime = null;
    if (down == null || downTime == null) {
      return;
    }
    if ((event.position - down).distance > 28) {
      return;
    }
    if (DateTime.now().difference(downTime) >
        const Duration(milliseconds: 450)) {
      return;
    }
    unawaited(_playWordAtLyricsGlobal(event.position));
  }

  void _lyricsPointerCancel(PointerCancelEvent event) {
    _lyricsPtrDown = null;
    _lyricsPtrDownTime = null;
  }

  Widget _lyricsContextMenu(
      BuildContext menuContext, EditableTextState editableTextState) {
    final List<ContextMenuButtonItem> items =
        editableTextState.contextMenuButtonItems;
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: <ContextMenuButtonItem>[
        ...items,
        ContextMenuButtonItem(
          label: 'Đánh vần đoạn này',
          onPressed: () {
            final TextSelection sel =
                editableTextState.textEditingValue.selection;
            if (!sel.isValid || sel.isCollapsed) {
              editableTextState.hideToolbar();
              ScaffoldMessenger.of(menuContext).showSnackBar(
                SnackBar(
                  content: Text(
                    'Bôi đen chữ trước nhé!',
                    style: TextStyle(
                        fontSize: 18,
                        color:
                            Theme.of(menuContext).colorScheme.onInverseSurface),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
            final int a = sel.start;
            final int b = sel.end;
            editableTextState.hideToolbar();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              unawaited(_viewModel.startSpellSnippetForRange(a, b));
            });
          },
        ),
      ],
    );
  }

  Widget _kidFilledButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: _kidTapMin + 8,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(label),
      ),
    );
  }

  Widget _focusClusterChip({
    required String label,
    required BuildContext context,
    double fontSize = 16,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _focusClustersRow(BuildContext context, String focusWord) {
    final VietnameseSpellingDisplayParts? parts =
        VietnameseEducationalSpellingDisplay.displayPartsForToken(
      focusWord,
    );
    if (parts == null) {
      return const SizedBox.shrink();
    }
    final List<String> labels = <String>[];
    if (parts.onset.isNotEmpty) {
      labels.add(parts.onset);
    }
    labels.addAll(parts.rhymeChips);
    final String toneGlyph =
        VietnameseEducationalSpelling.toneMarkDisplay(parts.toneName);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          ...labels.map(
            (String item) => _focusClusterChip(
              label: item,
              context: context,
            ),
          ),
          if (toneGlyph.isNotEmpty)
            _focusClusterChip(
              label: toneGlyph,
              context: context,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    unawaited(
      StudySessionRecorder.instance.leaveSubject(StudySubjectKeys.reading),
    );
    _uiSubscription?.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _draftController.dispose();
    _lyricsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReadingPracticeViewModel vm = _viewModel;
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color softBg =
        Color.lerp(cs.surfaceContainerLowest, const Color(0xFFFFF9E6), 0.35)!;
    final bool canReplay = vm.canReplayLastSpell ||
        (vm.highlightStart >= 0 && vm.highlightEnd > vm.highlightStart);
    final bool showInputPanel = vm.appliedText.trim().isEmpty;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: softBg,
        appBar: AppBar(
          title: Text(
            'Đánh vần'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
          ),
          elevation: 0,
          backgroundColor: cs.primaryContainer.withValues(alpha: 0.65),
          actions: <Widget>[
            IconButton(
              tooltip: 'Dán',
              onPressed: _screenLocked
                  ? null
                  : () => unawaited(_pasteFromClipboardAndRevealEditor()),
              icon: const Icon(Icons.content_paste_go_rounded),
            ),
            IconButton(
              tooltip: 'Tốc độ đọc',
              onPressed: _screenLocked
                  ? null
                  : () => unawaited(_showSpeedDialog(context)),
              icon: const Icon(Icons.speed_rounded),
            ),
            IconButton(
              tooltip: 'Giọng đọc',
              onPressed: _screenLocked
                  ? null
                  : () => unawaited(_showVoiceDialog(context)),
              icon: const Icon(Icons.record_voice_over_rounded),
            ),
            IconButton(
              tooltip: _screenLocked ? 'Mở khoá' : 'Khoá',
              onPressed: () => unawaited(_toggleScreenLock()),
              icon: Icon(
                  _screenLocked ? Icons.lock_open_rounded : Icons.lock_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (showInputPanel)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Gõ hoặc dán bài đọc',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _draftController,
                            readOnly: _screenLocked,
                            minLines: 5,
                            maxLines: 12,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(fontSize: 22, height: 1.45),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Ví dụ: Hôm nay em đọc sách…',
                              hintStyle:
                                  TextStyle(fontSize: 20, color: cs.outline),
                              contentPadding: const EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_bodyRadius),
                                borderSide: BorderSide(
                                    color: cs.outline.withValues(alpha: 0.35),
                                    width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_bodyRadius),
                                borderSide: BorderSide(
                                    color: cs.outline.withValues(alpha: 0.35),
                                    width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(_bodyRadius),
                                borderSide:
                                    BorderSide(color: cs.primary, width: 3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _kidFilledButton(
                            onPressed: _screenLocked
                                ? null
                                : () => vm.applyScript(_draftController.text),
                            icon: Icons.visibility_rounded,
                            label: 'Hiện bài đọc',
                            backgroundColor: cs.tertiary,
                            foregroundColor: cs.onTertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 2),
                            child: Text(
                              'Sau khi hiện bài đọc, chạm chữ để đánh vần; bôi đen → menu “Đánh vần đoạn này”.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: _kidTapMin,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: vm.canPlay
                                  ? () => unawaited(vm.play())
                                  : null,
                              icon: const Icon(Icons.record_voice_over_rounded,
                                  size: 26),
                              label: const Text('Đọc hết bài'),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: vm.canPause ? 'Tạm dừng' : 'Tiếp tục',
                          iconSize: 30,
                          onPressed: vm.canPause
                              ? () => unawaited(vm.pausePlayback())
                              : (vm.canResume
                                  ? () => unawaited(vm.resumePlayback())
                                  : null),
                          icon: Icon(vm.canPause
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Material(
                      elevation: 3,
                      shadowColor: cs.shadow.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(_bodyRadius),
                      color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_bodyRadius),
                        child: Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: _lyricsPointerDown,
                          onPointerMove: _lyricsPointerMove,
                          onPointerUp: _lyricsPointerUp,
                          onPointerCancel: _lyricsPointerCancel,
                          child: SingleChildScrollView(
                            controller: _lyricsScrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: SelectableText.rich(
                              key: _paragraphKey,
                              TextSpan(
                                style: _baseLyricsStyle(context),
                                children:
                                    ReadingHighlightSpanBuilder.buildLyricSpans(
                                  appliedText: vm.appliedText,
                                  highlightStart: vm.highlightStart,
                                  highlightEnd: vm.highlightEnd,
                                  baseStyle: _baseLyricsStyle(context),
                                  onSurface: cs.onSurface,
                                ),
                              ),
                              contextMenuBuilder: _lyricsContextMenu,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(_bodyRadius),
                    color: cs.secondaryContainer.withValues(alpha: 0.85),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Từ đang học',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: cs.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            vm.largeFocusCaption.isEmpty
                                ? '…'
                                : vm.largeFocusCaption,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: _focusWordSize,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                              color: cs.onSecondaryContainer,
                            ),
                          ),
                          if (vm.largeFocusCaption.isNotEmpty)
                            _focusClustersRow(context, vm.largeFocusCaption),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: _kidTapMin + 10,
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: canReplay
                                  ? () => unawaited(_replayFocusOrLastSpell())
                                  : null,
                              icon: const Icon(Icons.replay_rounded, size: 30),
                              label: const Text('Phát lại'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
