import 'package:flutter/material.dart';
import 'package:location_app/language_study/data/dictionary_models.dart';

import 'language_study_word_detail_sheet.dart';

/// @deprecated Dùng [showLanguageStudyWordDetail].
Future<void> showLanguageStudyEnViWordDetail(
  BuildContext context,
  EnVnLookupResult result,
) => showLanguageStudyWordDetail(context, result);
