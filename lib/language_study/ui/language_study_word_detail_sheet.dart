import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/language_study/data/dictionary_models.dart';
import 'package:location_app/theme/kid_friendly_adaptive.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';

/// Bottom sheet: headword, IPA, và các nghĩa — chữ lớn cho trẻ.
Future<void> showLanguageStudyWordDetail(
  BuildContext context,
  DictionaryLookupResult result,
) async {
  final AppLocalizations l = AppLocalizations.of(context)!;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(KidFriendlyLayout.cardRadius),
      ),
    ),
    builder: (BuildContext ctx) {
      final ColorScheme scheme = Theme.of(ctx).colorScheme;
      final TextTheme textTheme = Theme.of(ctx).textTheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.88,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Material(
                    color: ctx.kidTintSurface(KidFriendlyColors.languageTint),
                    borderRadius:
                        BorderRadius.circular(KidFriendlyLayout.buttonRadius),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Text(
                        result.word,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: KidFriendlyColors.bodyText,
                        ),
                      ),
                    ),
                  ),
                  if (result.pronunciations.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: result.pronunciations.map(
                        (DictionaryPronunciation p) {
                          final String? r = p.region?.trim();
                          final String label =
                              r != null && r.isNotEmpty ? '${p.ipa} · $r' : p.ipa;
                          return Chip(
                            visualDensity: VisualDensity.compact,
                            backgroundColor: scheme.surfaceContainerLow,
                            side: BorderSide.none,
                            label: Text(
                              label,
                              style: textTheme.titleSmall?.copyWith(
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    l.languageStudyMeaningsHeading,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: KidFriendlyColors.lavenderPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...result.senses.asMap().entries.map(
                    (MapEntry<int, DictionarySense> e) {
                      final DictionarySense s = e.value;
                      final bool last = e.key == result.senses.length - 1;
                      final String posBits = <String?>[
                        s.pos?.trim(),
                        s.subPos?.trim(),
                      ].whereType<String>().where((String x) => x.isNotEmpty).join(' · ');
                      return Padding(
                        padding: EdgeInsets.only(bottom: last ? 0 : 12),
                        child: Material(
                          color: scheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                            KidFriendlyLayout.buttonRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (posBits.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  posBits,
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: scheme.tertiary,
                                  ),
                                ),
                              ),
                            Text(
                              s.definition,
                              style: textTheme.titleLarge?.copyWith(
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (s.example != null && s.example!.trim().isNotEmpty) ...<Widget>[
                              const SizedBox(height: 8),
                              Text(
                                '${l.languageStudyExampleLabel}: ${s.example!.trim()}',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: scheme.onSurfaceVariant,
                                  height: 1.35,
                                ),
                              ),
                            ],
                            if (s.sourceName != null &&
                                s.sourceName!.trim().isNotEmpty) ...<Widget>[
                              const SizedBox(height: 6),
                              Text(
                                '${l.languageStudySourceLabel}: ${s.sourceName!.trim()}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(KidFriendlyLayout.minTapTarget),
                    ),
                    child: Text(l.mathDialogOk),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
