import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/language_study/data/dictionary_models.dart';
import 'package:location_app/language_study/data/language_study_dictionary_repository.dart';
import 'package:location_app/language_study/data/language_study_learned_words_store.dart';
import 'package:location_app/language_study/model/language_pair_id.dart';
import 'package:location_app/language_study/model/language_study_pos_topic.dart';
import 'package:location_app/language_study/service/language_study_tts_service.dart';

import 'language_study_ui_controller.dart';

/// Lưới 20 từ học (từ + nghĩa + IPA); chạm để nghe tiếng Anh.
class LanguageStudyWordListScreen extends StatefulWidget {
  const LanguageStudyWordListScreen({
    super.key,
    required this.pair,
  });

  final LanguagePairId pair;

  @override
  State<LanguageStudyWordListScreen> createState() =>
      _LanguageStudyWordListScreenState();
}

class _LanguageStudyWordListScreenState extends State<LanguageStudyWordListScreen> {
  static const int _sessionSize = 20;

  final LanguageStudyUiController _ui = LanguageStudyUiController();
  late final LanguageStudyDictionaryRepository _repo = widget.pair.createRepository();

  bool _busy = true;
  String? _error;
  String? _topicCode;
  List<DictionaryListItem> _items = <DictionaryListItem>[];
  double _ttsSpeed = 0.5;

  @override
  void initState() {
    super.initState();
    _ui.addListener(_onUi);
    _ttsSpeed = LanguageStudyTtsService.instance.speedSlider;
    unawaited(_load());
  }

  void _onUi() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
      _topicCode = null;
    });
    try {
      await _repo.warmUp();
      await LanguageStudyTtsService.instance.ensureReady();
      List<DictionaryListItem> items;
      String? topicCode;
      final DictionaryTopicBatch batch =
          await _repo.randomHeadwordsByTopic(limit: _sessionSize);
      items = batch.items;
      topicCode = batch.topicCode;
      if (items.isNotEmpty) {
        await LanguageStudyLearnedWordsStore.instance.addLearnedWordIds(
          widget.pair,
          items.map((DictionaryListItem e) => e.wordId),
        );
      }
      if (mounted) {
        setState(() {
          _items = items;
          _topicCode = topicCode;
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _busy = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _ui.removeListener(_onUi);
    _ui.dispose();
    unawaited(LanguageStudyTtsService.instance.stop());
    super.dispose();
  }

  Future<void> _onWillPop() async {
    await _ui.confirmExitIfUnlocked(context);
  }

  Future<void> _speakWord(DictionaryListItem item) async {
    if (_ui.screenLocked) {
      _ui.showLockedSnack(context);
      return;
    }
    try {
      await LanguageStudyTtsService.instance.speakEnglish(item.headword);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _showSpeedDialog() async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    double local = _ttsSpeed;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setLocal) {
            return AlertDialog(
              title: Text(l.languageStudyTtsSpeedTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Slider(
                    value: local,
                    onChanged: (double v) {
                      setLocal(() {
                        local = v;
                      });
                    },
                  ),
                  Text(
                    l.languageStudyTtsSpeedHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l.mathCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l.mathDialogOk),
                ),
              ],
            );
          },
        );
      },
    );
    if (ok != true || !mounted) {
      return;
    }
    await LanguageStudyTtsService.instance.setSpeedSlider(local);
    setState(() {
      _ttsSpeed = local;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_onWillPop());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.languageStudyLearn20AppBar),
          actions: <Widget>[
            IconButton(
              tooltip: l.languageStudyTtsSpeedTitle,
              onPressed: () => unawaited(_showSpeedDialog()),
              icon: const Icon(Icons.speed_rounded),
            ),
            IconButton(
              tooltip: l.languageStudyLockScreenTitle,
              onPressed: () => unawaited(_ui.toggleScreenLock(context, l)),
              icon: Icon(
                _ui.screenLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              ),
            ),
          ],
        ),
        body: _busy
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      l.languageStudyPreparingDb,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              )
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '${l.languageStudyDbError}\n$_error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.error),
                      ),
                    ),
                  )
                : _items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l.languageStudyDbError,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (_topicCode != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              child: Material(
                                color: scheme.primaryContainer.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.category_rounded,
                                        color: scheme.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          l.languageStudyTopicBanner(
                                            LanguageStudyPosTopic.label(
                                              l,
                                              _topicCode!,
                                            ),
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Text(
                              l.languageStudyTapToListen,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.92,
                              ),
                              itemCount: _items.length,
                              itemBuilder: (BuildContext context, int i) {
                                final DictionaryListItem item = _items[i];
                                return _WordGridCard(
                                  index: i + 1,
                                  item: item,
                                  onTap: () => unawaited(_speakWord(item)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}

class _WordGridCard extends StatelessWidget {
  const _WordGridCard({
    required this.index,
    required this.item,
    required this.onTap,
  });

  final int index;
  final DictionaryListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? ipa = item.ipaPreview?.trim();
    final String? meaning = item.meaningPreview?.trim();
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 14,
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.volume_up_rounded,
                    size: 22,
                    color: scheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.headword,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              if (ipa != null && ipa.isNotEmpty) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  ipa,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: scheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
              const Spacer(),
              if (meaning != null && meaning.isNotEmpty)
                Text(
                  meaning,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                    height: 1.25,
                  ),
                )
              else
                Text(
                  '—',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
