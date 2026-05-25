import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/language_study/model/language_pair_id.dart';
import 'package:location_app/language_study/ui/language_study_en_vi_entry_screen.dart';

/// Chọn cặp ngôn ngữ; cặp chưa làm chỉ hiển thị **Sắp có** (UI thống nhất cho scale sau).
class LanguageStudyHubScreen extends StatelessWidget {
  const LanguageStudyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.languageStudyHubTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: <Widget>[
          Text(
            l.languageStudyHubPickPair,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          _PairCard(
            title: LanguagePairId.enVi.title(l),
            subtitle: LanguagePairId.enVi.subtitle(l),
            icon: Icons.translate_rounded,
            iconColor: scheme.primary,
            background: scheme.primaryContainer.withValues(alpha: 0.55),
            enabled: LanguagePairId.enVi.isImplemented,
            onTap: LanguagePairId.enVi.isImplemented
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext ctx) =>
                            const LanguageStudyEnViEntryScreen(),
                      ),
                    );
                  }
                : null,
          ),
          const SizedBox(height: 12),
          _PairCard(
            title: LanguagePairId.zhVi.title(l),
            subtitle: LanguagePairId.zhVi.subtitle(l),
            icon: Icons.translate_rounded,
            iconColor: scheme.secondary,
            background: scheme.secondaryContainer.withValues(alpha: 0.5),
            enabled: LanguagePairId.zhVi.isImplemented,
            onTap: null,
          ),
          const SizedBox(height: 12),
          _PairCard(
            title: LanguagePairId.zhEn.title(l),
            subtitle: LanguagePairId.zhEn.subtitle(l),
            icon: Icons.translate_rounded,
            iconColor: scheme.tertiary,
            background: scheme.tertiaryContainer.withValues(alpha: 0.5),
            enabled: LanguagePairId.zhEn.isImplemented,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.enabled,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (!enabled)
                Chip(
                  label: Text(l.languageStudyChipSoon),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  backgroundColor:
                      Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
