import 'package:flutter/material.dart';
import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/theme/kid_friendly_colors.dart';

import 'study_subject_keys.dart';

/// Icon + màu theo môn học (theo dõi, chi tiết phiên).
class StudySubjectVisual {
  const StudySubjectVisual({
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final IconData icon;
  final Color tint;
  final Color iconColor;

  Color screenBackgroundFor(BuildContext context) {
    return KidFriendlyColors.screenBackground(
      tint,
      brightness: Theme.of(context).brightness,
    );
  }

  Color barBackgroundFor(BuildContext context) {
    return KidFriendlyColors.barBackground(
      tint,
      brightness: Theme.of(context).brightness,
    );
  }
}

StudySubjectVisual studySubjectVisual(String subjectKey) {
  switch (subjectKey) {
    case StudySubjectKeys.reading:
      return const StudySubjectVisual(
        icon: Icons.menu_book_rounded,
        tint: KidFriendlyColors.readingTint,
        iconColor: KidFriendlyColors.skyPrimary,
      );
    case StudySubjectKeys.math:
      return const StudySubjectVisual(
        icon: Icons.calculate_rounded,
        tint: KidFriendlyColors.mathTint,
        iconColor: KidFriendlyColors.mintGreen,
      );
    case StudySubjectKeys.alphabet:
      return const StudySubjectVisual(
        icon: Icons.abc_rounded,
        tint: KidFriendlyColors.alphabetTint,
        iconColor: KidFriendlyColors.warmCoral,
      );
    case StudySubjectKeys.languageStudyEnVi:
      return const StudySubjectVisual(
        icon: Icons.translate_rounded,
        tint: KidFriendlyColors.languageTint,
        iconColor: KidFriendlyColors.lavenderPrimary,
      );
    default:
      return const StudySubjectVisual(
        icon: Icons.school_rounded,
        tint: KidFriendlyColors.creamBackground,
        iconColor: KidFriendlyColors.bodyText,
      );
  }
}

String studySubjectLabel(AppLocalizations l, String subjectKey) {
  switch (subjectKey) {
    case StudySubjectKeys.reading:
      return l.homeSubjectReadingTitle;
    case StudySubjectKeys.math:
      return l.homeSubjectMathTitle;
    case StudySubjectKeys.alphabet:
      return l.homeSubjectAlphabetTitle;
    case StudySubjectKeys.languageStudyEnVi:
      return l.languageStudyPairEnVnTitle;
    default:
      return subjectKey;
  }
}
