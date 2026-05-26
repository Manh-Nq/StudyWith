import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/theme/kid_friendly_adaptive.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';
import 'package:location_app/reading_practice/service/reading_tts_service.dart';
import 'package:location_app/reading_practice/service/vietnamese_educational_spelling.dart';
import 'package:location_app/study_tracking/study_session_recorder.dart';
import 'package:location_app/study_tracking/study_subject_keys.dart';

import '../data/alphabet_listen_chu_tail.dart';
import '../data/alphabet_override_repository.dart';
import '../model/alphabet_card_view_data.dart';
import 'alphabet_illustration.dart';
import 'alphabet_letters_catalog_screen.dart';

/// Đánh vần SGK từng **từ** trong cụm ví dụ tiếng Việt (chỉ màn chữ cái; không dùng trong tập đọc).
Future<void> _speakAlphabetVietnameseSpellingPhrase(
  ReadingTtsService tts,
  String phraseVi,
  bool Function() stale,
) async {
  final List<String> tokens = phraseVi
      .trim()
      .split(RegExp(r'\s+'))
      .where((String w) => w.isNotEmpty)
      .toList();
  if (tokens.isEmpty) {
    return;
  }
  for (int wi = 0; wi < tokens.length; wi++) {
    if (stale()) {
      return;
    }
    final String word = tokens[wi];
    final List<String>? steps =
        VietnameseEducationalSpelling.speakStepsForToken(word);
    if (steps == null || steps.isEmpty) {
      await tts.speak(word);
    } else {
      for (int i = 0; i < steps.length; i++) {
        if (stale()) {
          return;
        }
        final String raw = steps[i];
        final bool isLast = i == steps.length - 1;
        final String speak = isLast
            ? raw
            : VietnameseEducationalSpelling.ttsSpeakForIntermediateLetterStep(raw);
        await tts.speak(speak);
        if (stale()) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 420));
      }
      if (stale()) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 280));
      await tts.speak(word);
    }
    if (wi < tokens.length - 1) {
      if (stale()) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 380));
    }
  }
  if (tokens.length > 1) {
    if (stale()) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (stale()) {
      return;
    }
    await tts.speak(phraseVi.trim());
  }
}

/// Làm quen chữ cái & đánh vần (lớp 1) — nghe tên chữ / ví dụ, đánh vần tiếng mẫu.
class VietnameseAlphabetScreen extends StatefulWidget {
  const VietnameseAlphabetScreen({super.key});

  @override
  State<VietnameseAlphabetScreen> createState() => _VietnameseAlphabetScreenState();
}

class _VietnameseAlphabetScreenState extends State<VietnameseAlphabetScreen> {
  late final ReadingTtsService _tts = ReadingTtsService.create();
  final AlphabetOverrideRepository _alphabetRepository =
      AlphabetOverrideRepository();
  List<AlphabetCardViewData> _cards = <AlphabetCardViewData>[];
  bool _cardsLoading = true;
  String? _busyListenLetter;
  String? _busySpellLetter;
  int _ttsPlaybackGeneration = 0;

  @override
  void initState() {
    super.initState();
    unawaited(
      StudySessionRecorder.instance.enterSubject(StudySubjectKeys.alphabet),
    );
    unawaited(_initTts());
    unawaited(_loadCards());
  }

  Future<void> _loadCards() async {
    final List<AlphabetCardViewData> next =
        await _alphabetRepository.loadAllViewData();
    if (!mounted) {
      return;
    }
    setState(() {
      _cards = next;
      _cardsLoading = false;
    });
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('vi-VN');
    await ReadingTtsService.configureSpeechRateForPlatform(
      service: _tts,
      normalizedSlider: 0.35,
    );
    await _tts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    unawaited(
      StudySessionRecorder.instance.leaveSubject(StudySubjectKeys.alphabet),
    );
    unawaited(_tts.dispose());
    super.dispose();
  }

  Future<void> _listenLetter(AlphabetCardViewData data, AppLocalizations l) async {
    final int gen = ++_ttsPlaybackGeneration;
    final String localeCode = Localizations.localeOf(context).languageCode;
    bool stale() => !mounted || gen != _ttsPlaybackGeneration;
    await _tts.stop();
    if (stale()) {
      return;
    }
    setState(() {
      _busyListenLetter = data.letterDisplay;
      _busySpellLetter = null;
    });
    try {
      if (localeCode == 'vi') {
        final String tail = alphabetListenChuTailVi(data.letterDisplay);
        final String preamble = 'Chữ $tail';
        await _tts.speak(preamble);
        if (stale()) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 280));
        if (stale()) {
          return;
        }
        await _tts.speak(data.exampleVi.trim());
      } else {
        final String example =
            '${data.exampleVi} (${data.exampleEn})';
        await _tts.speak('${data.letterDisplay}. $example');
      }
      if (!stale()) {
        StudySessionRecorder.instance.recordAlphabetListenCompleted();
      }
    } catch (_) {
      if (!stale() && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.alphabetTtsError)),
        );
      }
    } finally {
      if (mounted && gen == _ttsPlaybackGeneration) {
        setState(() {
          _busyListenLetter = null;
        });
      }
    }
  }

  Future<void> _spellSyllable(AlphabetCardViewData data, AppLocalizations l) async {
    final int gen = ++_ttsPlaybackGeneration;
    bool stale() => !mounted || gen != _ttsPlaybackGeneration;
    await _tts.stop();
    if (stale()) {
      return;
    }
    setState(() {
      _busySpellLetter = data.letterDisplay;
      _busyListenLetter = null;
    });
    bool spellOk = false;
    try {
      final String phrase = data.exampleVi.trim();
      if (phrase.isEmpty) {
        await _speakAlphabetVietnameseSpellingPhrase(
          _tts,
          data.spellSyllableVi,
          stale,
        );
      } else {
        await _speakAlphabetVietnameseSpellingPhrase(_tts, phrase, stale);
      }
      if (!stale()) {
        spellOk = true;
      }
    } catch (_) {
      if (!stale() && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.alphabetTtsError)),
        );
      }
    } finally {
      if (spellOk) {
        StudySessionRecorder.instance.recordAlphabetSpellCompleted();
      }
      if (mounted && gen == _ttsPlaybackGeneration) {
        setState(() {
          _busySpellLetter = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor:
          context.kidScreenBackground(KidFriendlyColors.alphabetTint),
      appBar: AppBar(
        backgroundColor: context.kidBarBackground(KidFriendlyColors.alphabetTint),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: Text(
          l.alphabetScreenTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: scheme.onSurface,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: l.alphabetEditCardsTooltip,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (BuildContext ctx) =>
                      const AlphabetLettersCatalogScreen(),
                ),
              );
              if (mounted) {
                await _loadCards();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _cardsLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(
                        l.alphabetScreenSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final AlphabetCardViewData data = _cards[index];
                          final bool listenBusy =
                              _busyListenLetter == data.letterDisplay;
                          final bool spellBusy =
                              _busySpellLetter == data.letterDisplay;
                          final String locale =
                              Localizations.localeOf(context).languageCode;
                          final String example = locale == 'vi'
                              ? data.exampleVi
                              : data.exampleEn;
                          return _AlphabetCard(
                            data: data,
                            exampleLine: example,
                            listenBusy: listenBusy,
                            spellBusy: spellBusy,
                            listenLabel: l.alphabetListenLetter,
                            spellLabel: l.alphabetSpell,
                            onListen: () => unawaited(_listenLetter(data, l)),
                            onSpell: () => unawaited(_spellSyllable(data, l)),
                          );
                        },
                        childCount: _cards.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AlphabetCard extends StatelessWidget {
  const _AlphabetCard({
    required this.data,
    required this.exampleLine,
    required this.listenBusy,
    required this.spellBusy,
    required this.listenLabel,
    required this.spellLabel,
    required this.onListen,
    required this.onSpell,
  });
  final AlphabetCardViewData data;
  final String exampleLine;
  final bool listenBusy;
  final bool spellBusy;
  final String listenLabel;
  final String spellLabel;
  final VoidCallback onListen;
  final VoidCallback onSpell;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool cardAudioBusy = listenBusy || spellBusy;
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
        onTap: cardAudioBusy ? null : onListen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: data.base.illustrationBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: AlphabetIllustration(data: data, size: 52),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.letterDisplay,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: data.letterDisplay.length <= 1
                      ? 34
                      : (data.letterDisplay.length == 2 ? 28 : 22),
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exampleLine,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.25,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: cardAudioBusy ? null : onListen,
                icon: listenBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.volume_up_rounded, size: 20),
                label: Text(listenLabel),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle:
                      const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              const SizedBox(height: 6),
              FilledButton.icon(
                onPressed: cardAudioBusy ? null : onSpell,
                icon: spellBusy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.record_voice_over_rounded, size: 20),
                label: Text(spellLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: KidFriendlyColors.mintGreen,
                  foregroundColor: theme.colorScheme.onTertiary,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  textStyle:
                      const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
