import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(l.alphabetCatalogTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    l.alphabetCatalogSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (BuildContext context, int index) {
                      final AlphabetCardViewData data = _items[index];
                      return Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 48,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: data.base.illustrationBackground,
                                borderRadius: BorderRadius.circular(10),
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
                          trailing: const Icon(Icons.chevron_right_rounded),
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
