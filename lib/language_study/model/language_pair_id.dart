import 'package:location_app/l10n/app_localizations.dart';
import 'package:location_app/language_study/data/en_vn_dictionary_repository.dart';
import 'package:location_app/language_study/data/language_study_dictionary_repository.dart';

/// Cặp học ngôn ngữ (mở rộng sau: [zhVi], [zhEn], …).
enum LanguagePairId {
  enVi,
  zhVi,
  zhEn,
}

extension LanguagePairIdUi on LanguagePairId {
  bool get isImplemented => this == LanguagePairId.enVi;

  LanguageStudyDictionaryRepository createRepository() {
    switch (this) {
      case LanguagePairId.enVi:
        return EnVnDictionaryRepository();
      case LanguagePairId.zhVi:
      case LanguagePairId.zhEn:
        throw UnsupportedError('Pair not implemented: $this');
    }
  }

  String title(AppLocalizations l) {
    switch (this) {
      case LanguagePairId.enVi:
        return l.languageStudyPairEnVnTitle;
      case LanguagePairId.zhVi:
        return l.languageStudyPairZhViTitle;
      case LanguagePairId.zhEn:
        return l.languageStudyPairZhEnTitle;
    }
  }

  String subtitle(AppLocalizations l) {
    switch (this) {
      case LanguagePairId.enVi:
        return l.languageStudyPairEnVnSubtitle;
      case LanguagePairId.zhVi:
        return l.languageStudyPairZhViSubtitle;
      case LanguagePairId.zhEn:
        return l.languageStudyPairZhEnSubtitle;
    }
  }

  String appBarTitle(AppLocalizations l) {
    switch (this) {
      case LanguagePairId.enVi:
        return l.languageStudyEnViAppBarTitle;
      case LanguagePairId.zhVi:
      case LanguagePairId.zhEn:
        return title(l);
    }
  }

  String searchHint(AppLocalizations l) {
    switch (this) {
      case LanguagePairId.enVi:
        return l.languageStudySearchHint;
      case LanguagePairId.zhVi:
      case LanguagePairId.zhEn:
        return l.languageStudySearchHint;
    }
  }

  String trySampleLabel(AppLocalizations l) {
    switch (this) {
      case LanguagePairId.enVi:
        return l.languageStudyTryHello;
      case LanguagePairId.zhVi:
      case LanguagePairId.zhEn:
        return l.languageStudyTryHello;
    }
  }

  String trySampleWord() {
    switch (this) {
      case LanguagePairId.enVi:
        return 'hello';
      case LanguagePairId.zhVi:
      case LanguagePairId.zhEn:
        return 'hello';
    }
  }
}
