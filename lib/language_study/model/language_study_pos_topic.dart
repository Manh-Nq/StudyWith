import 'package:location_app/l10n/app_localizations.dart';

/// Nhãn chủ đề học (ánh xạ mã POS trong DB).
abstract final class LanguageStudyPosTopic {
  static String label(AppLocalizations l, String topicCode) {
    switch (topicCode) {
      case 'N':
        return l.languageStudyTopicNoun;
      case 'V':
        return l.languageStudyTopicVerb;
      case 'A':
        return l.languageStudyTopicAdjective;
      case 'D':
        return l.languageStudyTopicAdverb;
      default:
        return topicCode;
    }
  }
}
