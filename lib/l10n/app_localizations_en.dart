// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Learning app';

  @override
  String get homeAppBarTitle => 'Learning';

  @override
  String get homeTabSubjects => 'Subjects';

  @override
  String get homeTabComingSoon => 'Coming soon';

  @override
  String get homeTabSettings => 'Settings';

  @override
  String get homeTabTracking => 'Tracking';

  @override
  String get homePickSubject => 'Pick a subject to start';

  @override
  String get homeSubjectReadingTitle => 'Reading';

  @override
  String get homeSubjectReadingSubtitle => 'Vietnamese reading & practice';

  @override
  String get homeSubjectMathTitle => 'Math';

  @override
  String get homeSubjectMathSubtitle => 'Thinking math';

  @override
  String get homeSubjectLanguageTitle => 'Languages';

  @override
  String get homeSubjectLanguageSubtitle =>
      'Offline dictionary — English first';

  @override
  String get languageStudyHubTitle => 'Language study';

  @override
  String get languageStudyHubPickPair => 'Choose a language pair';

  @override
  String get languageStudyPairEnVnTitle => 'English → Vietnamese';

  @override
  String get languageStudyPairEnVnSubtitle => 'Look up words offline';

  @override
  String get languageStudyPairZhViTitle => 'Chinese → Vietnamese';

  @override
  String get languageStudyPairZhViSubtitle => 'Planned for a later update';

  @override
  String get languageStudyPairZhEnTitle => 'Chinese → English';

  @override
  String get languageStudyPairZhEnSubtitle => 'Planned for a later update';

  @override
  String get languageStudyChipSoon => 'Soon';

  @override
  String get languageStudyUnlockTitle => 'Unlock';

  @override
  String get languageStudyLockScreenTitle => 'Lock this screen';

  @override
  String get languageStudyExitTitle => 'Leave language study?';

  @override
  String get languageStudyExitMessage => 'You will go back to the home screen.';

  @override
  String get languageStudyScreenLockedSnack =>
      'This screen is locked. Tap the lock icon and enter your password.';

  @override
  String get languageStudyEnViAppBarTitle => 'English · Vietnamese';

  @override
  String get languageStudyPreparingDb => 'Preparing dictionary…';

  @override
  String get languageStudyDbReady => 'Dictionary is ready.';

  @override
  String get languageStudyDbError => 'Could not open the dictionary.';

  @override
  String get languageStudyTryHello => 'Try: hello';

  @override
  String get languageStudySearchHint => 'Type an English word…';

  @override
  String get languageStudyLookupTooltip => 'Look up';

  @override
  String get languageStudyClearSearchTooltip => 'Clear';

  @override
  String get languageStudyTypeForSuggestions =>
      'Keep typing to see word suggestions.';

  @override
  String get languageStudyNoSuggestions => 'No matching words yet.';

  @override
  String get languageStudyNoWordFound => 'No dictionary entry for that word.';

  @override
  String get languageStudyMeaningsHeading => 'Meanings';

  @override
  String get languageStudyExampleLabel => 'Example';

  @override
  String get languageStudySourceLabel => 'Source';

  @override
  String get languageStudyLearn20Button => 'Learn 20 random words';

  @override
  String get languageStudyReview20Button => 'Review 20 learned words';

  @override
  String get languageStudyLearn20AppBar => 'Learn · 20 words';

  @override
  String get languageStudyReview20AppBar => 'Review · 20 words';

  @override
  String get languageStudyReviewEmpty =>
      'No words learned yet. Open \"Learn 20 random words\" first.';

  @override
  String languageStudyTopicBanner(String topic) {
    return 'Topic: $topic';
  }

  @override
  String get languageStudyTopicNoun => 'Nouns';

  @override
  String get languageStudyTopicVerb => 'Verbs';

  @override
  String get languageStudyTopicAdjective => 'Adjectives';

  @override
  String get languageStudyTopicAdverb => 'Adverbs';

  @override
  String get languageStudyTapToListen => 'Tap a card to hear the English word';

  @override
  String get languageStudyTtsSpeedTitle => 'Speech speed';

  @override
  String get languageStudyTtsSpeedHint => 'Slower ← → Faster';

  @override
  String languageStudyQuizProgress(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get languageStudyQuizPickMeaning =>
      'Pick the correct Vietnamese meaning';

  @override
  String get languageStudyQuizNext => 'Next';

  @override
  String get languageStudyQuizFinish => 'Finish';

  @override
  String get languageStudyQuizDoneTitle => 'Review complete';

  @override
  String languageStudyQuizDoneBody(int correct, int total) {
    return 'You got $correct out of $total correct.';
  }

  @override
  String languageStudyLearnedCount(int count) {
    return '$count words seen in study';
  }

  @override
  String get languageStudyAttribution =>
      'Dictionary data: minhqnd (CC BY-SA 4.0) · dict.minhqnd.com';

  @override
  String get homeSoonEnglishTitle => 'English';

  @override
  String get homeSoonEnglishSubtitle =>
      'Vocabulary and listening — in preparation';

  @override
  String get homeSoonOtherTitle => 'More subjects';

  @override
  String get homeSoonOtherSubtitle => 'Will be added over time';

  @override
  String get homeChipComingSoon => 'Soon';

  @override
  String homeComingSoonSnack(String title) {
    return '\"$title\" will be added later.';
  }

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Choose app language';

  @override
  String get settingsLanguageVietnamese => 'Vietnamese';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get mathListAppBarTitle => 'Math thinking activities';

  @override
  String get mathGroupNumberCounting => 'Numbers & counting';

  @override
  String get mathGroupSimpleOperations => 'Simple operations';

  @override
  String get mathGroupGeometrySpace => 'Geometry & space';

  @override
  String get mathGroupClassificationLogic => 'Sorting & logic';

  @override
  String get mathActCountingTitle => 'Count objects, pick the answer';

  @override
  String get mathActCountingDesc =>
      'Count the objects, then choose one of two answers.';

  @override
  String get mathActCompareTitle => 'Compare: more / less / equal';

  @override
  String get mathActCompareDesc =>
      'Look at two groups and pick the correct relation.';

  @override
  String get mathActSequenceTitle => 'Fill in the missing number';

  @override
  String get mathActSequenceDesc => 'Example: 1, 2, ?, 4, 5.';

  @override
  String get mathActSortTitle => 'Sort numbers up / down';

  @override
  String get mathActSortDesc => 'Arrange the number list in order.';

  @override
  String get mathActAddSubTitle => 'Add & subtract within 10 and 20';

  @override
  String get mathActAddSubDesc => 'Practice basic addition and subtraction.';

  @override
  String get mathActPictureTitle => 'Picture word problems';

  @override
  String get mathActPictureDesc => 'Example: 3 chickens + 2 chickens = ?';

  @override
  String get mathPictureSumLimitDialogTitle => 'Addition limit';

  @override
  String get mathPictureSumLimitDialogBody =>
      'Each problem uses two groups; their total will not exceed this number.';

  @override
  String get mathPictureSumLimitLabel => 'Maximum total (e.g. 10)';

  @override
  String get mathPictureSumLimitInvalid => 'Enter a whole number.';

  @override
  String mathPictureSumLimitOutOfRange(int min, int max) {
    return 'Total must be between $min and $max.';
  }

  @override
  String get mathPictureAddCountHint =>
      'Count the pictures, then pick the total.';

  @override
  String get mathPictureAddLayoutHint =>
      'Count each group, then choose the answer below.';

  @override
  String get mathActFillOpTitle => 'Fill in +, -, =';

  @override
  String get mathActFillOpDesc => 'Pick the correct operation sign.';

  @override
  String get mathActShapesTitle => 'Recognize shapes';

  @override
  String get mathActShapesDesc => 'Circle, square, triangle, rectangle.';

  @override
  String get mathActSizeCompareTitle =>
      'Big / small, tall / short, long / short';

  @override
  String get mathActSizeCompareDesc => 'Look and pick the correct description.';

  @override
  String get mathActPositionTitle => 'Recognize position';

  @override
  String get mathActPositionDesc =>
      'Above / below, left / right, inside / outside.';

  @override
  String get mathActOddOneTitle => 'Find the odd one out';

  @override
  String get mathActOddOneDesc =>
      'Example: cat, dog, car — which is different?';

  @override
  String get mathActPatternTitle => 'Complete the pattern';

  @override
  String get mathActPatternDesc => 'Example: red, blue, red, blue, …';

  @override
  String get mathActMatchingTitle => 'Match pairs';

  @override
  String get mathActMatchingDesc => 'Animal — food, object — use.';

  @override
  String get mathActSameDiffTitle => 'Same or different?';

  @override
  String get mathActSameDiffDesc => 'Look and pick the best answer.';

  @override
  String get mathPlaceholderBody =>
      'This activity will be added in a future update.';

  @override
  String get mathCountingScreenTitle => 'Thinking math';

  @override
  String get mathExamStartTitle => 'Start test';

  @override
  String get mathExamDurationLabel => 'Test duration';

  @override
  String get mathExamTimePerQuestionLabel => 'Time limit per question';

  @override
  String get mathExamMinutes5 => '5 minutes';

  @override
  String get mathExamMinutes10 => '10 minutes';

  @override
  String get mathExamMinutes15 => '15 minutes';

  @override
  String get mathExamMinutes20 => '20 minutes';

  @override
  String get mathExamSeconds30PerQ => '30 seconds / question';

  @override
  String get mathExamSeconds45PerQ => '45 seconds / question';

  @override
  String get mathExamSeconds60PerQ => '60 seconds / question';

  @override
  String get mathExamSeconds90PerQ => '90 seconds / question';

  @override
  String mathExamEstimatedQuestions(int count) {
    return 'Estimated questions: $count';
  }

  @override
  String get mathCancel => 'Cancel';

  @override
  String get mathStart => 'Start';

  @override
  String get mathExamResultTitle => 'Test results';

  @override
  String mathExamScoreColon(int score, int total) {
    return 'Score: $score / $total';
  }

  @override
  String mathExamCorrectCount(int n) {
    return 'Correct: $n';
  }

  @override
  String mathExamWrongCount(int n) {
    return 'Wrong: $n';
  }

  @override
  String get mathExamRetry => 'Retake test';

  @override
  String get mathExamBackToPractice => 'Back to practice';

  @override
  String get mathScreenLockedSnack =>
      'Screen is locked. Tap Unlock and enter the password.';

  @override
  String get mathLockMathScreenTitle => 'Lock math screen';

  @override
  String get mathPasswordHint => 'Password';

  @override
  String get mathUnlockTitle => 'Unlock';

  @override
  String get mathPasswordEntryTitle => 'Enter password';

  @override
  String get mathDialogLock => 'Lock';

  @override
  String get mathDialogUnlock => 'Unlock';

  @override
  String get mathDialogOk => 'OK';

  @override
  String get mathWrongPasswordSnack => 'Wrong password. Please try again.';

  @override
  String get mathExitTitle => 'Leave math?';

  @override
  String get mathExitMessage => 'Are you sure you want to go back?';

  @override
  String get mathExitStay => 'Stay';

  @override
  String get mathExitLeave => 'Leave';

  @override
  String get mathNoQuestion => 'No question available';

  @override
  String get mathTooltipOpenExam => 'Open test setup';

  @override
  String get mathTooltipUnlock => 'Unlock';

  @override
  String get mathTooltipLock => 'Lock';

  @override
  String get mathTooltipManageObjects => 'Manage objects';

  @override
  String get mathExamModeBanner => 'Mode: Test';

  @override
  String mathScoreRunning(int score, int total) {
    return 'Score: $score / $total';
  }

  @override
  String get mathCompareInstruction => 'Compare and pick the correct sign';

  @override
  String mathCountingQuestionHowMany(String name) {
    return 'How many $name?';
  }

  @override
  String get mathSequenceFillMissingHint => 'Fill in the missing number';

  @override
  String get mathSequenceModeDialogTitle => 'How should the number line work?';

  @override
  String get mathSequenceModeConsecutiveTitle => 'Count in order';

  @override
  String get mathSequenceModeConsecutiveSubtitle =>
      '1, 2, 3, 4, 5… — best for beginners';

  @override
  String get mathSequenceModeRandomTitle => 'Mixed steps';

  @override
  String get mathSequenceModeRandomSubtitle =>
      'Steps of 1, 2, or 3 — like before';

  @override
  String get mathSequenceModeConsecutiveChip => 'Count in order';

  @override
  String get mathSequenceModeRandomChip => 'Mixed steps';

  @override
  String get mathSortInstructionAscending => 'Sort in ascending order';

  @override
  String get mathSortInstructionDescending => 'Sort in descending order';

  @override
  String get mathAddSubPickAnswer => 'Pick the correct answer';

  @override
  String get mathEntityManagerTitle => 'Math objects';

  @override
  String get mathEntityNameLabel => 'Object name';

  @override
  String get mathEntityNameHint => 'Example: Apple';

  @override
  String get mathEntityImageSourceLabel => 'Image source';

  @override
  String get mathEntitySourceBase64 => 'Pick image on device (base64)';

  @override
  String get mathEntitySourceUrl => 'Image URL';

  @override
  String get mathEntitySourceVector => 'Default vector';

  @override
  String get mathEntityUrlLabel => 'Image URL';

  @override
  String get mathEntityUrlHint => 'https://…';

  @override
  String get mathEntityPickFromDevice => 'Pick image on device';

  @override
  String get mathEntityVectorShapeLabel => 'Default vector shape';

  @override
  String get mathEntityShapeCircle => 'Circle';

  @override
  String get mathEntityShapeSquare => 'Square';

  @override
  String get mathEntityShapeRectangle => 'Rectangle';

  @override
  String get mathEntityShapeTriangle => 'Triangle';

  @override
  String get mathEntityShapeStar => 'Star';

  @override
  String get mathEntityAddButton => 'Add object';

  @override
  String get mathEntitySnackNameRequired => 'Enter an object name';

  @override
  String get mathEntitySnackPickImage => 'Pick an image from the device';

  @override
  String get mathEntitySnackUrlRequired => 'Enter an image URL';

  @override
  String get mathEntitySnackAdded => 'Object added';

  @override
  String mathEntityAddFailed(String error) {
    return 'Could not add object: $error';
  }

  @override
  String mathEntitySubtitleVector(String value) {
    return 'Vector: $value';
  }

  @override
  String get mathEntitySubtitleBase64 => 'Image on device (base64)';

  @override
  String get mathEntityDeleteTooltip => 'Delete';

  @override
  String get mathEntityDeleteConfirmTitle => 'Delete this object?';

  @override
  String get mathEntityDeleteConfirmBody => 'This cannot be undone.';

  @override
  String get mathEntityDeleteConfirmAction => 'Delete';

  @override
  String get mathEntityDeleteCancel => 'Cancel';

  @override
  String get mathSizeCompareOptionLeftBigger => 'Left is bigger';

  @override
  String get mathSizeCompareOptionRightBigger => 'Right is bigger';

  @override
  String get mathSizeCompareOptionEqual => 'Equal';

  @override
  String get mathPositionTop => 'Top';

  @override
  String get mathPositionBottom => 'Bottom';

  @override
  String get mathPositionLeft => 'Left';

  @override
  String get mathPositionRight => 'Right';

  @override
  String get mathSameAnswerSame => 'Same';

  @override
  String get mathSameAnswerDifferent => 'Different';

  @override
  String get homeSubjectAlphabetTitle => 'Alphabet';

  @override
  String get homeSubjectAlphabetSubtitle =>
      'Letters, sounds & spelling (Grade 1)';

  @override
  String get alphabetScreenTitle => 'Learn the alphabet & spelling';

  @override
  String get alphabetScreenSubtitle =>
      'Tap a card to listen. Use Spelling to hear syllable-by-syllable blending.';

  @override
  String get alphabetListenLetter => 'Listen';

  @override
  String get alphabetSpell => 'Spell';

  @override
  String get alphabetTtsError =>
      'Could not play audio. Check device volume and try again.';

  @override
  String get alphabetEditCardsTooltip => 'Customize cards';

  @override
  String get alphabetCatalogTitle => 'Alphabet cards';

  @override
  String get alphabetCatalogSubtitle =>
      'Tap a letter to change example text, spelling word, or picture.';

  @override
  String alphabetEditorTitle(String letter) {
    return 'Edit: $letter';
  }

  @override
  String get alphabetEditorExampleVi => 'Example (Vietnamese)';

  @override
  String get alphabetEditorExampleEn => 'Example (English)';

  @override
  String get alphabetEditorSpell => 'Spelling syllable (Vietnamese)';

  @override
  String get alphabetEditorSpellHint => 'Used for “Spell” — e.g. lá, cá, tre';

  @override
  String get alphabetEditorImageSection => 'Illustration';

  @override
  String get alphabetEditorImageIcon => 'Default icon';

  @override
  String get alphabetEditorImageDevice => 'Photo from device';

  @override
  String get alphabetEditorImageUrl => 'Image URL';

  @override
  String get alphabetEditorUrlHint => 'https://…';

  @override
  String get alphabetEditorPickImage => 'Pick image';

  @override
  String get alphabetEditorSave => 'Save';

  @override
  String get alphabetEditorReset => 'Restore defaults';

  @override
  String get alphabetEditorResetTitle => 'Restore defaults?';

  @override
  String get alphabetEditorResetBody =>
      'This card will use the built-in example and icon again.';

  @override
  String get alphabetEditorSaved => 'Saved';

  @override
  String get alphabetEditorValidationExample => 'Enter the Vietnamese example';

  @override
  String get alphabetEditorValidationSpell => 'Enter the spelling syllable';

  @override
  String get alphabetEditorValidationUrl => 'Enter an image URL';

  @override
  String get alphabetEditorValidationImage => 'Pick an image from the device';

  @override
  String get studyTrackingEmpty =>
      'No study sessions yet. Open a subject and study — times and results will appear here.';

  @override
  String get studyTrackingTimeLabel => 'Time';

  @override
  String studyTrackingStatsLine(int total, int correct, int wrong) {
    return '$total questions · $correct correct · $wrong wrong';
  }

  @override
  String get studyTrackingDeleteTooltip => 'Delete record';

  @override
  String get studyTrackingDeleteTitle => 'Delete this session?';

  @override
  String get studyTrackingDeleteBody =>
      'This study record will be removed from history.';

  @override
  String get studyTrackingCancel => 'Cancel';

  @override
  String get studyTrackingConfirmDelete => 'Delete';

  @override
  String get studySessionDetailTitle => 'Session details';

  @override
  String get studySessionDetailEmptyAttempts =>
      'No saved question details for this session.';

  @override
  String studySessionDetailQuestionIndex(int index) {
    return 'Question $index';
  }

  @override
  String get studySessionDetailYourAnswer => 'Your answer';

  @override
  String get studySessionDetailCorrectAnswer => 'Correct answer';

  @override
  String get studySessionDetailCorrectLabel => 'Correct';

  @override
  String get studySessionDetailWrongLabel => 'Wrong';

  @override
  String get studySessionDetailActivityType => 'Activity type';

  @override
  String get studySessionDetailOpenTooltip => 'View details';

  @override
  String get studySessionDetailRelationMore => 'Greater (more)';

  @override
  String get studySessionDetailRelationLess => 'Less';

  @override
  String get studySessionDetailRelationEqual => 'Equal';

  @override
  String get studySessionDetailSortAscending => 'Ascending';

  @override
  String get studySessionDetailSortDescending => 'Descending';
}
