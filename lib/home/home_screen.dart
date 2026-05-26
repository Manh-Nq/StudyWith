import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';

import 'package:location_app/language_study/ui/language_study_hub_screen.dart';
import 'package:location_app/locale/app_locale_scope.dart';
import 'package:location_app/theme/app_theme_mode_scope.dart';
import 'package:location_app/theme/kid_friendly_adaptive.dart';
import 'package:location_app/math_thinking/view/math_activity_list_screen.dart';
import 'package:location_app/reading_practice/view/reading_practice_screen.dart';
import 'package:location_app/study_tracking/study_tracking_tab.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';
import 'package:location_app/theme/kid_friendly_menu_layout.dart';
import 'package:location_app/theme/kid_friendly_theme.dart';
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
    final double screenW = MediaQuery.sizeOf(context).width;
    final double hPad = math.max(
      KidFriendlyLayout.screenPadding,
      (screenW - KidFriendlyMenuLayout.maxContentWidth) / 2,
    );
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 8),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    scheme.primaryContainer.withValues(alpha: 0.85),
                    scheme.secondaryContainer.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(KidFriendlyLayout.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.waving_hand_rounded,
                        size: 32,
                        color: scheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l.homePickSubject,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 24),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: KidFriendlyMenuLayout.crossAxisCount(
                math.min(screenW - hPad * 2, KidFriendlyMenuLayout.maxContentWidth),
              ),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: KidFriendlyMenuLayout.cardAspectRatio(
                math.min(screenW - hPad * 2, KidFriendlyMenuLayout.maxContentWidth),
              ),
            ),
            delegate: SliverChildListDelegate(
              <Widget>[
                KidFriendlyHeroMenuCard(
                  title: l.homeSubjectReadingTitle,
                  subtitle: l.homeSubjectReadingSubtitle,
                  icon: Icons.menu_book_rounded,
                  iconColor: KidFriendlyColors.skyPrimary,
                  background: context.kidSubjectCardBackground(
                    KidFriendlyColors.readingTint,
                  ),
                  onTap: onReading,
                ),
                KidFriendlyHeroMenuCard(
                  title: l.homeSubjectAlphabetTitle,
                  subtitle: l.homeSubjectAlphabetSubtitle,
                  icon: Icons.abc_rounded,
                  iconColor: KidFriendlyColors.warmCoral,
                  background: context.kidSubjectCardBackground(
                    KidFriendlyColors.alphabetTint,
                  ),
                  onTap: onAlphabet,
                ),
                KidFriendlyHeroMenuCard(
                  title: l.homeSubjectMathTitle,
                  subtitle: l.homeSubjectMathSubtitle,
                  icon: Icons.calculate_rounded,
                  iconColor: KidFriendlyColors.mintGreen,
                  background: context.kidSubjectCardBackground(
                    KidFriendlyColors.mathTint,
                  ),
                  onTap: onMath,
                ),
                KidFriendlyHeroMenuCard(
                  title: l.homeSubjectLanguageTitle,
                  subtitle: l.homeSubjectLanguageSubtitle,
                  icon: Icons.translate_rounded,
                  iconColor: KidFriendlyColors.lavenderPrimary,
                  background: context.kidSubjectCardBackground(
                    KidFriendlyColors.languageTint,
                  ),
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
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (BuildContext ctx, int index) {
        final _SoonRow item = rows[index];
        final ColorScheme scheme = Theme.of(context).colorScheme;
        return Card(
          elevation: 0,
          color: Color.lerp(
            scheme.surface,
            KidFriendlyColors.sunnyYellow.withValues(alpha: 0.25),
            0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: KidFriendlyColors.sunnyYellow.withValues(alpha: 0.35),
              child: Icon(item.icon, color: KidFriendlyColors.warmCoral),
            ),
            title: Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
            trailing: Chip(
              label: Text(l.homeChipComingSoon),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide.none,
              backgroundColor: scheme.surface.withValues(alpha: 0.92),
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
    final AppLocaleScope localeScope = AppLocaleScope.of(context);
    final AppThemeModeScope themeScope = AppThemeModeScope.of(context);
    final String localeCode = localeScope.locale.languageCode;
    final String themeCode =
        themeScope.themeMode == ThemeMode.dark ? 'dark' : 'light';
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: <Widget>[
        _SettingsSectionHeader(
          icon: Icons.dark_mode_rounded,
          iconColor: scheme.primary,
          title: l.settingsAppearanceTitle,
          subtitle: l.settingsAppearanceSubtitle,
          bannerTint: context.kidTintSurface(KidFriendlyColors.languageTint),
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'light',
              label: Text(l.settingsThemeLight),
              icon: const Icon(Icons.light_mode_rounded),
            ),
            ButtonSegment<String>(
              value: 'dark',
              label: Text(l.settingsThemeDark),
              icon: const Icon(Icons.dark_mode_rounded),
            ),
          ],
          selected: <String>{themeCode},
          onSelectionChanged: (Set<String> selection) {
            final String next = selection.first;
            themeScope.setThemeMode(
              next == 'dark' ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
        const SizedBox(height: 28),
        _SettingsSectionHeader(
          icon: Icons.language_rounded,
          iconColor: KidFriendlyColors.lavenderPrimary,
          title: l.settingsLanguageTitle,
          subtitle: l.settingsLanguageSubtitle,
          bannerTint: context.kidTintSurface(KidFriendlyColors.languageTint),
        ),
        const SizedBox(height: 12),
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
          selected: <String>{localeCode},
          onSelectionChanged: (Set<String> selection) {
            final String next = selection.first;
            localeScope.setLocale(Locale(next));
          },
        ),
      ],
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.bannerTint,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color bannerTint;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      color: bannerTint,
      borderRadius: BorderRadius.circular(KidFriendlyLayout.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
