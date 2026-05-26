import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/language_study/data/dictionary_models.dart';
import 'package:location_app/language_study/data/en_vn_dictionary_repository.dart';
import 'package:location_app/language_study/data/language_study_learned_words_store.dart';
import 'package:location_app/language_study/model/language_pair_id.dart';
import 'package:location_app/language_study/model/language_study_session_mode.dart';
import 'package:location_app/theme/kid_friendly_adaptive.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';

import 'language_study_ui_controller.dart';
import 'language_study_word_detail_sheet.dart';
import 'language_study_review_quiz_screen.dart';
import 'language_study_word_list_screen.dart';

/// Màn **EN–VN**: chuẩn bị DB, tra cứu + gợi ý prefix, chi tiết từ (bottom sheet).
class LanguageStudyEnViEntryScreen extends StatefulWidget {
  const LanguageStudyEnViEntryScreen({super.key});

  @override
  State<LanguageStudyEnViEntryScreen> createState() =>
      _LanguageStudyEnViEntryScreenState();
}

class _LanguageStudyEnViEntryScreenState extends State<LanguageStudyEnViEntryScreen> {
  static const Duration _suggestDebounce = Duration(milliseconds: 280);

  final LanguageStudyUiController _ui = LanguageStudyUiController();
  final EnVnDictionaryRepository _repo = EnVnDictionaryRepository();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  bool _busy = true;
  String? _error;
  int _learnedCount = 0;
  Timer? _debounceTimer;
  int _suggestGen = 0;
  List<String> _suggestions = <String>[];
  bool _suggestLoading = false;

  @override
  void initState() {
    super.initState();
    _ui.addListener(_onUi);
    _searchController.addListener(_onSearchTextChanged);
    unawaited(_prepare());
  }

  void _onUi() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    final String q = EnVnDictionaryRepository.normalizeEnglishInput(_searchController.text);
    if (q.isEmpty) {
      setState(() {
        _suggestions = <String>[];
        _suggestLoading = false;
      });
      return;
    }
    setState(() {
      _suggestLoading = true;
    });
    _debounceTimer = Timer(_suggestDebounce, () => unawaited(_runSuggest(q)));
  }

  Future<void> _runSuggest(String normalizedPrefix) async {
    final int gen = ++_suggestGen;
    try {
      final List<String> list = await _repo.suggestEnglishPrefix(
        normalizedPrefix,
        limit: 20,
      );
      if (!mounted || gen != _suggestGen) {
        return;
      }
      setState(() {
        _suggestions = list;
        _suggestLoading = false;
      });
    } catch (_) {
      if (!mounted || gen != _suggestGen) {
        return;
      }
      setState(() {
        _suggestions = <String>[];
        _suggestLoading = false;
      });
    }
  }

  Future<void> _prepare() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _repo.lookupEnglishToVietnamese('hello');
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
    if (mounted) {
      final int count = await LanguageStudyLearnedWordsStore.instance
          .learnedCount(LanguagePairId.enVi);
      setState(() {
        _learnedCount = count;
        _busy = false;
      });
    }
  }

  void _openWordList(LanguageStudySessionMode mode) {
    if (_ui.screenLocked) {
      _ui.showLockedSnack(context);
      return;
    }
    final Widget screen = mode == LanguageStudySessionMode.reviewRandom20
        ? const LanguageStudyReviewQuizScreen(pair: LanguagePairId.enVi)
        : const LanguageStudyWordListScreen(pair: LanguagePairId.enVi);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext ctx) => screen),
    ).then((_) {
      if (mounted) {
        unawaited(_refreshLearnedCount());
      }
    });
  }

  Future<void> _refreshLearnedCount() async {
    final int count = await LanguageStudyLearnedWordsStore.instance
        .learnedCount(LanguagePairId.enVi);
    if (mounted) {
      setState(() {
        _learnedCount = count;
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    _ui.removeListener(_onUi);
    _ui.dispose();
    super.dispose();
  }

  Future<void> _onWillPop() async {
    Navigator.of(context).pop();
  }

  bool get _inputLocked => _ui.screenLocked || _busy;

  Future<void> _lookupAndShow(String rawWord) async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    if (_ui.screenLocked) {
      _ui.showLockedSnack(context);
      return;
    }
    final String w = rawWord.trim();
    if (w.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      final EnVnLookupResult? result = await _repo.lookupEnglishToVietnamese(w);
      if (!mounted) {
        return;
      }
      if (result == null || result.senses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.languageStudyNoWordFound)),
        );
        return;
      }
      await LanguageStudyLearnedWordsStore.instance.addLearnedWordIds(
        LanguagePairId.enVi,
        <int>[result.wordId],
      );
      unawaited(_refreshLearnedCount());
      if (!mounted) {
        return;
      }
      await showLanguageStudyWordDetail(context, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.languageStudyDbError}\n$e')),
        );
      }
    }
  }

  Future<void> _tryHello() async {
    _searchController.text = 'hello';
    await _lookupAndShow('hello');
  }

  void _clearSearch() {
    if (_inputLocked) {
      return;
    }
    _searchController.clear();
    _searchFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          unawaited(_onWillPop());
        }
      },
      child: Scaffold(
        backgroundColor:
            context.kidScreenBackground(KidFriendlyColors.languageTint),
        appBar: AppBar(
          backgroundColor:
              context.kidBarBackground(KidFriendlyColors.languageTint),
          title: Text(l.languageStudyEnViAppBarTitle),
          actions: <Widget>[
            IconButton(
              tooltip: l.languageStudyLockScreenTitle,
              onPressed: () => unawaited(_ui.toggleScreenLock(context, l)),
              icon: Icon(
                _ui.screenLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                LanguagePairId.enVi.title(l),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l.languageStudyAttribution,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              if (_busy)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l.languageStudyPreparingDb,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_error != null)
                Expanded(
                  child: Center(
                    child: Text(
                      '${l.languageStudyDbError}\n$_error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Material(
                        color: context.kidTintSurface(KidFriendlyColors.languageTint),
                        borderRadius: BorderRadius.circular(KidFriendlyLayout.buttonRadius),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_rounded,
                                color: KidFriendlyColors.lavenderPrimary,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l.languageStudyDbReady,
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
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _busy
                            ? null
                            : () {
                                if (_ui.screenLocked) {
                                  _ui.showLockedSnack(context);
                                  return;
                                }
                                _openWordList(LanguageStudySessionMode.learnRandom20);
                              },
                        icon: const Icon(Icons.school_rounded),
                        label: Text(l.languageStudyLearn20Button),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () {
                                if (_ui.screenLocked) {
                                  _ui.showLockedSnack(context);
                                  return;
                                }
                                _openWordList(LanguageStudySessionMode.reviewRandom20);
                              },
                        icon: const Icon(Icons.fact_check_rounded),
                        label: Text(l.languageStudyReview20Button),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (_learnedCount > 0) ...<Widget>[
                        const SizedBox(height: 6),
                        Text(
                          l.languageStudyLearnedCount(_learnedCount),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        enabled: !_inputLocked,
                        textInputAction: TextInputAction.search,
                        autocorrect: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: l.languageStudySearchHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  tooltip: l.languageStudyClearSearchTooltip,
                                  onPressed: _inputLocked ? null : _clearSearch,
                                  icon: const Icon(Icons.clear_rounded),
                                ),
                              IconButton(
                                tooltip: l.languageStudyLookupTooltip,
                                onPressed: _busy
                                    ? null
                                    : () {
                                        if (_ui.screenLocked) {
                                          _ui.showLockedSnack(context);
                                          return;
                                        }
                                        unawaited(_lookupAndShow(_searchController.text));
                                      },
                                icon: const Icon(Icons.arrow_forward_rounded),
                              ),
                            ],
                          ),
                        ),
                        onSubmitted: (String _) {
                          if (_busy) {
                            return;
                          }
                          if (_ui.screenLocked) {
                            _ui.showLockedSnack(context);
                            return;
                          }
                          unawaited(_lookupAndShow(_searchController.text));
                        },
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: _buildSuggestionPanel(l)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () {
                                if (_ui.screenLocked) {
                                  _ui.showLockedSnack(context);
                                  return;
                                }
                                unawaited(_tryHello());
                              },
                        icon: const Icon(Icons.waving_hand_rounded),
                        label: Text(l.languageStudyTryHello),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionPanel(AppLocalizations l) {
    final String q =
        EnVnDictionaryRepository.normalizeEnglishInput(_searchController.text);
    if (q.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            l.languageStudyTypeForSuggestions,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
          ),
        ),
      );
    }
    if (_suggestLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_suggestions.isEmpty) {
      return Center(
        child: Text(
          l.languageStudyNoSuggestions,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
      itemCount: _suggestions.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
      itemBuilder: (BuildContext context, int i) {
        final String word = _suggestions[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          title: Text(
            word,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {
            if (_inputLocked) {
              if (_ui.screenLocked) {
                _ui.showLockedSnack(context);
              }
              return;
            }
            unawaited(_lookupAndShow(word));
          },
        );
      },
      ),
    );
  }
}
