import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/theme/kid_friendly_adaptive.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';

import '../data/alphabet_override_repository.dart';
import '../model/alphabet_card_view_data.dart';
import 'alphabet_illustration.dart';
import 'alphabet_letter_editor_screen.dart';

class AlphabetLettersCatalogScreen extends StatefulWidget {
  const AlphabetLettersCatalogScreen({super.key});

  @override
  State<AlphabetLettersCatalogScreen> createState() =>
      _AlphabetLettersCatalogScreenState();
}

class _AlphabetLettersCatalogScreenState
    extends State<AlphabetLettersCatalogScreen> {
  final AlphabetOverrideRepository _repository = AlphabetOverrideRepository();
  List<AlphabetCardViewData> _items = <AlphabetCardViewData>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_reload());
  }

  Future<void> _reload() async {
    final List<AlphabetCardViewData> next = await _repository.loadAllViewData();
    if (!mounted) {
      return;
    }
    setState(() {
      _items = next;
      _loading = false;
    });
  }

  Future<void> _openEditor(AlphabetCardViewData data) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext ctx) => AlphabetLetterEditorScreen(viewData: data),
      ),
    );
    if (mounted) {
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:
          context.kidScreenBackground(KidFriendlyColors.alphabetTint),
      appBar: AppBar(
        backgroundColor: context.kidBarBackground(KidFriendlyColors.alphabetTint),
        title: Text(l.alphabetCatalogTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Material(
                    color: context.kidTintSurface(KidFriendlyColors.alphabetTint),
                    borderRadius:
                        BorderRadius.circular(KidFriendlyLayout.buttonRadius),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        l.alphabetCatalogSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) {
                      final AlphabetCardViewData data = _items[index];
                      return Card(
                        elevation: 0,
                        color: scheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            KidFriendlyLayout.cardRadius,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          leading: SizedBox(
                            width: 48,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: data.base.illustrationBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: AlphabetIllustration(
                                  data: data,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            data.letterDisplay,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${data.exampleVi} · ${data.exampleEn}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                          onTap: () => unawaited(_openEditor(data)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
