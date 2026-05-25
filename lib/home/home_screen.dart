import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/language_study/ui/language_study_hub_screen.dart';
import 'package:location_app/locale/app_locale_scope.dart';
import 'package:location_app/math_thinking/view/math_activity_list_screen.dart';
import 'package:location_app/reading_practice/view/reading_practice_screen.dart';
import 'package:location_app/study_tracking/study_tracking_tab.dart';
import 'package:location_app/vietnamese_alphabet/view/vietnamese_alphabet_screen.dart';

/// Trang chủ: chọn môn dạng lưới; tab Cài đặt để đổi ngôn ngữ.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openReading(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => const ReadingPracticeScreen(),
      ),
    );
  }

  void _openMath(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => const MathActivityListScreen(),
      ),
    );
  }

  void _openAlphabet(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => const VietnameseAlphabetScreen(),
      ),
    );
  }

  void _openLanguageStudy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext ctx) => const LanguageStudyHubScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.homeAppBarTitle),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.grid_view_rounded),
                text: l.homeTabSubjects,
              ),
              Tab(
                icon: const Icon(Icons.insights_rounded),
                text: l.homeTabTracking,
              ),
              Tab(
                icon: const Icon(Icons.list_rounded),
                text: l.homeTabComingSoon,
              ),
              Tab(
                icon: const Icon(Icons.settings_rounded),
                text: l.homeTabSettings,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _SubjectsGrid(
              onReading: () => _openReading(context),
              onMath: () => _openMath(context),
              onAlphabet: () => _openAlphabet(context),
              onLanguageStudy: () => _openLanguageStudy(context),
            ),
            const StudyTrackingTab(),
            const _ComingSoonList(),
            const _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

class _SubjectsGrid extends StatelessWidget {
  const _SubjectsGrid({
    required this.onReading,
    required this.onMath,
    required this.onAlphabet,
    required this.onLanguageStudy,
  });
  final VoidCallback onReading;
  final VoidCallback onMath;
  final VoidCallback onAlphabet;
  final VoidCallback onLanguageStudy;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              l.homePickSubject,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.92,
            ),
            delegate: SliverChildListDelegate(
              <Widget>[
                _SubjectCard(
                  title: l.homeSubjectReadingTitle,
                  subtitle: l.homeSubjectReadingSubtitle,
                  icon: Icons.menu_book_rounded,
                  iconColor: scheme.primary,
                  background: scheme.primaryContainer.withValues(alpha: 0.65),
                  onTap: onReading,
                ),
                _SubjectCard(
                  title: l.homeSubjectAlphabetTitle,
                  subtitle: l.homeSubjectAlphabetSubtitle,
                  icon: Icons.abc_rounded,
                  iconColor: scheme.secondary,
                  background: scheme.secondaryContainer.withValues(alpha: 0.75),
                  onTap: onAlphabet,
                ),
                _SubjectCard(
                  title: l.homeSubjectMathTitle,
                  subtitle: l.homeSubjectMathSubtitle,
                  icon: Icons.calculate_rounded,
                  iconColor: scheme.tertiary,
                  background: scheme.tertiaryContainer.withValues(alpha: 0.65),
                  onTap: onMath,
                ),
                _SubjectCard(
                  title: l.homeSubjectLanguageTitle,
                  subtitle: l.homeSubjectLanguageSubtitle,
                  icon: Icons.translate_rounded,
                  iconColor: scheme.primary,
                  background: scheme.primaryContainer.withValues(alpha: 0.45),
                  onTap: onLanguageStudy,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: iconColor),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoonRow {
  const _SoonRow({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final IconData icon;
}

class _ComingSoonList extends StatelessWidget {
  const _ComingSoonList();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    void snack(String message) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    final List<_SoonRow> rows = <_SoonRow>[
      _SoonRow(
        title: l.homeSoonOtherTitle,
        subtitle: l.homeSoonOtherSubtitle,
        icon: Icons.auto_awesome_mosaic_rounded,
      ),
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (BuildContext ctx, int index) {
        final _SoonRow item = rows[index];
        return Card(
          elevation: 0,
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.55),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child:
                  Icon(item.icon, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.subtitle,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            trailing: Chip(
              label: Text(l.homeChipComingSoon),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide.none,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            onTap: () => snack(l.homeComingSoonSnack(item.title)),
          ),
        );
      },
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final AppLocaleScope scope = AppLocaleScope.of(context);
    final String code = scope.locale.languageCode;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: <Widget>[
        Text(
          l.settingsLanguageTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          l.settingsLanguageSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        SegmentedButton<String>(
          segments: <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'vi',
              label: Text(l.settingsLanguageVietnamese),
              icon: const Icon(Icons.flag_rounded),
            ),
            ButtonSegment<String>(
              value: 'en',
              label: Text(l.settingsLanguageEnglish),
              icon: const Icon(Icons.flag_outlined),
            ),
          ],
          selected: <String>{code},
          onSelectionChanged: (Set<String> selection) {
            final String next = selection.first;
            scope.setLocale(Locale(next));
          },
        ),
      ],
    );
  }
}
