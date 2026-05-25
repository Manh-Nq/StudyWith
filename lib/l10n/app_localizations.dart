import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning app'**
  String get appTitle;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get homeAppBarTitle;

  /// No description provided for @homeTabSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get homeTabSubjects;

  /// No description provided for @homeTabComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeTabComingSoon;

  /// No description provided for @homeTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeTabSettings;

  /// No description provided for @homeTabTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get homeTabTracking;

  /// No description provided for @homePickSubject.
  ///
  /// In en, this message translates to:
  /// **'Pick a subject to start'**
  String get homePickSubject;

  /// No description provided for @homeSubjectReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get homeSubjectReadingTitle;

  /// No description provided for @homeSubjectReadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese reading & practice'**
  String get homeSubjectReadingSubtitle;

  /// No description provided for @homeSubjectMathTitle.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get homeSubjectMathTitle;

  /// No description provided for @homeSubjectMathSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thinking math'**
  String get homeSubjectMathSubtitle;

  /// No description provided for @homeSubjectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get homeSubjectLanguageTitle;

  /// No description provided for @homeSubjectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline dictionary — English first'**
  String get homeSubjectLanguageSubtitle;

  /// No description provided for @languageStudyHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Language study'**
  String get languageStudyHubTitle;

  /// No description provided for @languageStudyHubPickPair.
  ///
  /// In en, this message translates to:
  /// **'Choose a language pair'**
  String get languageStudyHubPickPair;

  /// No description provided for @languageStudyPairEnVnTitle.
  ///
  /// In en, this message translates to:
  /// **'English → Vietnamese'**
  String get languageStudyPairEnVnTitle;

  /// No description provided for @languageStudyPairEnVnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Look up words offline'**
  String get languageStudyPairEnVnSubtitle;

  /// No description provided for @languageStudyPairZhViTitle.
  ///
  /// In en, this message translates to:
  /// **'Chinese → Vietnamese'**
  String get languageStudyPairZhViTitle;

  /// No description provided for @languageStudyPairZhViSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Planned for a later update'**
  String get languageStudyPairZhViSubtitle;

  /// No description provided for @languageStudyPairZhEnTitle.
  ///
  /// In en, this message translates to:
  /// **'Chinese → English'**
  String get languageStudyPairZhEnTitle;

  /// No description provided for @languageStudyPairZhEnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Planned for a later update'**
  String get languageStudyPairZhEnSubtitle;

  /// No description provided for @languageStudyChipSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get languageStudyChipSoon;

  /// No description provided for @languageStudyUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get languageStudyUnlockTitle;

  /// No description provided for @languageStudyLockScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock this screen'**
  String get languageStudyLockScreenTitle;

  /// No description provided for @languageStudyExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave language study?'**
  String get languageStudyExitTitle;

  /// No description provided for @languageStudyExitMessage.
  ///
  /// In en, this message translates to:
  /// **'You will go back to the home screen.'**
  String get languageStudyExitMessage;

  /// No description provided for @languageStudyScreenLockedSnack.
  ///
  /// In en, this message translates to:
  /// **'This screen is locked. Tap the lock icon and enter your password.'**
  String get languageStudyScreenLockedSnack;

  /// No description provided for @languageStudyEnViAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'English · Vietnamese'**
  String get languageStudyEnViAppBarTitle;

  /// No description provided for @languageStudyPreparingDb.
  ///
  /// In en, this message translates to:
  /// **'Preparing dictionary…'**
  String get languageStudyPreparingDb;

  /// No description provided for @languageStudyDbReady.
  ///
  /// In en, this message translates to:
  /// **'Dictionary is ready.'**
  String get languageStudyDbReady;

  /// No description provided for @languageStudyDbError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the dictionary.'**
  String get languageStudyDbError;

  /// No description provided for @languageStudyTryHello.
  ///
  /// In en, this message translates to:
  /// **'Try: hello'**
  String get languageStudyTryHello;

  /// No description provided for @languageStudySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Type an English word…'**
  String get languageStudySearchHint;

  /// No description provided for @languageStudyLookupTooltip.
  ///
  /// In en, this message translates to:
  /// **'Look up'**
  String get languageStudyLookupTooltip;

  /// No description provided for @languageStudyClearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get languageStudyClearSearchTooltip;

  /// No description provided for @languageStudyTypeForSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Keep typing to see word suggestions.'**
  String get languageStudyTypeForSuggestions;

  /// No description provided for @languageStudyNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No matching words yet.'**
  String get languageStudyNoSuggestions;

  /// No description provided for @languageStudyNoWordFound.
  ///
  /// In en, this message translates to:
  /// **'No dictionary entry for that word.'**
  String get languageStudyNoWordFound;

  /// No description provided for @languageStudyMeaningsHeading.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get languageStudyMeaningsHeading;

  /// No description provided for @languageStudyExampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get languageStudyExampleLabel;

  /// No description provided for @languageStudySourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get languageStudySourceLabel;

  /// No description provided for @languageStudyLearn20Button.
  ///
  /// In en, this message translates to:
  /// **'Learn 20 random words'**
  String get languageStudyLearn20Button;

  /// No description provided for @languageStudyReview20Button.
  ///
  /// In en, this message translates to:
  /// **'Review 20 learned words'**
  String get languageStudyReview20Button;

  /// No description provided for @languageStudyLearn20AppBar.
  ///
  /// In en, this message translates to:
  /// **'Learn · 20 words'**
  String get languageStudyLearn20AppBar;

  /// No description provided for @languageStudyReview20AppBar.
  ///
  /// In en, this message translates to:
  /// **'Review · 20 words'**
  String get languageStudyReview20AppBar;

  /// No description provided for @languageStudyReviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'No words learned yet. Open \"Learn 20 random words\" first.'**
  String get languageStudyReviewEmpty;

  /// No description provided for @languageStudyTopicBanner.
  ///
  /// In en, this message translates to:
  /// **'Topic: {topic}'**
  String languageStudyTopicBanner(String topic);

  /// No description provided for @languageStudyTopicNoun.
  ///
  /// In en, this message translates to:
  /// **'Nouns'**
  String get languageStudyTopicNoun;

  /// No description provided for @languageStudyTopicVerb.
  ///
  /// In en, this message translates to:
  /// **'Verbs'**
  String get languageStudyTopicVerb;

  /// No description provided for @languageStudyTopicAdjective.
  ///
  /// In en, this message translates to:
  /// **'Adjectives'**
  String get languageStudyTopicAdjective;

  /// No description provided for @languageStudyTopicAdverb.
  ///
  /// In en, this message translates to:
  /// **'Adverbs'**
  String get languageStudyTopicAdverb;

  /// No description provided for @languageStudyTapToListen.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to hear the English word'**
  String get languageStudyTapToListen;

  /// No description provided for @languageStudyTtsSpeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech speed'**
  String get languageStudyTtsSpeedTitle;

  /// No description provided for @languageStudyTtsSpeedHint.
  ///
  /// In en, this message translates to:
  /// **'Slower ← → Faster'**
  String get languageStudyTtsSpeedHint;

  /// No description provided for @languageStudyQuizProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} / {total}'**
  String languageStudyQuizProgress(int current, int total);

  /// No description provided for @languageStudyQuizPickMeaning.
  ///
  /// In en, this message translates to:
  /// **'Pick the correct Vietnamese meaning'**
  String get languageStudyQuizPickMeaning;

  /// No description provided for @languageStudyQuizNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get languageStudyQuizNext;

  /// No description provided for @languageStudyQuizFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get languageStudyQuizFinish;

  /// No description provided for @languageStudyQuizDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Review complete'**
  String get languageStudyQuizDoneTitle;

  /// No description provided for @languageStudyQuizDoneBody.
  ///
  /// In en, this message translates to:
  /// **'You got {correct} out of {total} correct.'**
  String languageStudyQuizDoneBody(int correct, int total);

  /// No description provided for @languageStudyLearnedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words seen in study'**
  String languageStudyLearnedCount(int count);

  /// No description provided for @languageStudyAttribution.
  ///
  /// In en, this message translates to:
  /// **'Dictionary data: minhqnd (CC BY-SA 4.0) · dict.minhqnd.com'**
  String get languageStudyAttribution;

  /// No description provided for @homeSoonEnglishTitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get homeSoonEnglishTitle;

  /// No description provided for @homeSoonEnglishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary and listening — in preparation'**
  String get homeSoonEnglishSubtitle;

  /// No description provided for @homeSoonOtherTitle.
  ///
  /// In en, this message translates to:
  /// **'More subjects'**
  String get homeSoonOtherTitle;

  /// No description provided for @homeSoonOtherSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Will be added over time'**
  String get homeSoonOtherSubtitle;

  /// No description provided for @homeChipComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get homeChipComingSoon;

  /// No description provided for @homeComingSoonSnack.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be added later.'**
  String homeComingSoonSnack(String title);

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get settingsLanguageVietnamese;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @mathListAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Math thinking activities'**
  String get mathListAppBarTitle;

  /// No description provided for @mathGroupNumberCounting.
  ///
  /// In en, this message translates to:
  /// **'Numbers & counting'**
  String get mathGroupNumberCounting;

  /// No description provided for @mathGroupSimpleOperations.
  ///
  /// In en, this message translates to:
  /// **'Simple operations'**
  String get mathGroupSimpleOperations;

  /// No description provided for @mathGroupGeometrySpace.
  ///
  /// In en, this message translates to:
  /// **'Geometry & space'**
  String get mathGroupGeometrySpace;

  /// No description provided for @mathGroupClassificationLogic.
  ///
  /// In en, this message translates to:
  /// **'Sorting & logic'**
  String get mathGroupClassificationLogic;

  /// No description provided for @mathActCountingTitle.
  ///
  /// In en, this message translates to:
  /// **'Count objects, pick the answer'**
  String get mathActCountingTitle;

  /// No description provided for @mathActCountingDesc.
  ///
  /// In en, this message translates to:
  /// **'Count the objects, then choose one of two answers.'**
  String get mathActCountingDesc;

  /// No description provided for @mathActCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare: more / less / equal'**
  String get mathActCompareTitle;

  /// No description provided for @mathActCompareDesc.
  ///
  /// In en, this message translates to:
  /// **'Look at two groups and pick the correct relation.'**
  String get mathActCompareDesc;

  /// No description provided for @mathActSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the missing number'**
  String get mathActSequenceTitle;

  /// No description provided for @mathActSequenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Example: 1, 2, ?, 4, 5.'**
  String get mathActSequenceDesc;

  /// No description provided for @mathActSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort numbers up / down'**
  String get mathActSortTitle;

  /// No description provided for @mathActSortDesc.
  ///
  /// In en, this message translates to:
  /// **'Arrange the number list in order.'**
  String get mathActSortDesc;

  /// No description provided for @mathActAddSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Add & subtract within 10 and 20'**
  String get mathActAddSubTitle;

  /// No description provided for @mathActAddSubDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice basic addition and subtraction.'**
  String get mathActAddSubDesc;

  /// No description provided for @mathActPictureTitle.
  ///
  /// In en, this message translates to:
  /// **'Picture word problems'**
  String get mathActPictureTitle;

  /// No description provided for @mathActPictureDesc.
  ///
  /// In en, this message translates to:
  /// **'Example: 3 chickens + 2 chickens = ?'**
  String get mathActPictureDesc;

  /// No description provided for @mathPictureSumLimitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Addition limit'**
  String get mathPictureSumLimitDialogTitle;

  /// No description provided for @mathPictureSumLimitDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Each problem uses two groups; their total will not exceed this number.'**
  String get mathPictureSumLimitDialogBody;

  /// No description provided for @mathPictureSumLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum total (e.g. 10)'**
  String get mathPictureSumLimitLabel;

  /// No description provided for @mathPictureSumLimitInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number.'**
  String get mathPictureSumLimitInvalid;

  /// No description provided for @mathPictureSumLimitOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Total must be between {min} and {max}.'**
  String mathPictureSumLimitOutOfRange(int min, int max);

  /// No description provided for @mathPictureAddCountHint.
  ///
  /// In en, this message translates to:
  /// **'Count the pictures, then pick the total.'**
  String get mathPictureAddCountHint;

  /// No description provided for @mathPictureAddLayoutHint.
  ///
  /// In en, this message translates to:
  /// **'Count each group, then choose the answer below.'**
  String get mathPictureAddLayoutHint;

  /// No description provided for @mathActFillOpTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in +, -, ='**
  String get mathActFillOpTitle;

  /// No description provided for @mathActFillOpDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick the correct operation sign.'**
  String get mathActFillOpDesc;

  /// No description provided for @mathActShapesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize shapes'**
  String get mathActShapesTitle;

  /// No description provided for @mathActShapesDesc.
  ///
  /// In en, this message translates to:
  /// **'Circle, square, triangle, rectangle.'**
  String get mathActShapesDesc;

  /// No description provided for @mathActSizeCompareTitle.
  ///
  /// In en, this message translates to:
  /// **'Big / small, tall / short, long / short'**
  String get mathActSizeCompareTitle;

  /// No description provided for @mathActSizeCompareDesc.
  ///
  /// In en, this message translates to:
  /// **'Look and pick the correct description.'**
  String get mathActSizeCompareDesc;

  /// No description provided for @mathActPositionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize position'**
  String get mathActPositionTitle;

  /// No description provided for @mathActPositionDesc.
  ///
  /// In en, this message translates to:
  /// **'Above / below, left / right, inside / outside.'**
  String get mathActPositionDesc;

  /// No description provided for @mathActOddOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the odd one out'**
  String get mathActOddOneTitle;

  /// No description provided for @mathActOddOneDesc.
  ///
  /// In en, this message translates to:
  /// **'Example: cat, dog, car — which is different?'**
  String get mathActOddOneDesc;

  /// No description provided for @mathActPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the pattern'**
  String get mathActPatternTitle;

  /// No description provided for @mathActPatternDesc.
  ///
  /// In en, this message translates to:
  /// **'Example: red, blue, red, blue, …'**
  String get mathActPatternDesc;

  /// No description provided for @mathActMatchingTitle.
  ///
  /// In en, this message translates to:
  /// **'Match pairs'**
  String get mathActMatchingTitle;

  /// No description provided for @mathActMatchingDesc.
  ///
  /// In en, this message translates to:
  /// **'Animal — food, object — use.'**
  String get mathActMatchingDesc;

  /// No description provided for @mathActSameDiffTitle.
  ///
  /// In en, this message translates to:
  /// **'Same or different?'**
  String get mathActSameDiffTitle;

  /// No description provided for @mathActSameDiffDesc.
  ///
  /// In en, this message translates to:
  /// **'Look and pick the best answer.'**
  String get mathActSameDiffDesc;

  /// No description provided for @mathPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'This activity will be added in a future update.'**
  String get mathPlaceholderBody;

  /// No description provided for @mathCountingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Thinking math'**
  String get mathCountingScreenTitle;

  /// No description provided for @mathExamStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get mathExamStartTitle;

  /// No description provided for @mathExamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Test duration'**
  String get mathExamDurationLabel;

  /// No description provided for @mathExamTimePerQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Time limit per question'**
  String get mathExamTimePerQuestionLabel;

  /// No description provided for @mathExamMinutes5.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get mathExamMinutes5;

  /// No description provided for @mathExamMinutes10.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get mathExamMinutes10;

  /// No description provided for @mathExamMinutes15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get mathExamMinutes15;

  /// No description provided for @mathExamMinutes20.
  ///
  /// In en, this message translates to:
  /// **'20 minutes'**
  String get mathExamMinutes20;

  /// No description provided for @mathExamSeconds30PerQ.
  ///
  /// In en, this message translates to:
  /// **'30 seconds / question'**
  String get mathExamSeconds30PerQ;

  /// No description provided for @mathExamSeconds45PerQ.
  ///
  /// In en, this message translates to:
  /// **'45 seconds / question'**
  String get mathExamSeconds45PerQ;

  /// No description provided for @mathExamSeconds60PerQ.
  ///
  /// In en, this message translates to:
  /// **'60 seconds / question'**
  String get mathExamSeconds60PerQ;

  /// No description provided for @mathExamSeconds90PerQ.
  ///
  /// In en, this message translates to:
  /// **'90 seconds / question'**
  String get mathExamSeconds90PerQ;

  /// No description provided for @mathExamEstimatedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Estimated questions: {count}'**
  String mathExamEstimatedQuestions(int count);

  /// No description provided for @mathCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mathCancel;

  /// No description provided for @mathStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get mathStart;

  /// No description provided for @mathExamResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Test results'**
  String get mathExamResultTitle;

  /// No description provided for @mathExamScoreColon.
  ///
  /// In en, this message translates to:
  /// **'Score: {score} / {total}'**
  String mathExamScoreColon(int score, int total);

  /// No description provided for @mathExamCorrectCount.
  ///
  /// In en, this message translates to:
  /// **'Correct: {n}'**
  String mathExamCorrectCount(int n);

  /// No description provided for @mathExamWrongCount.
  ///
  /// In en, this message translates to:
  /// **'Wrong: {n}'**
  String mathExamWrongCount(int n);

  /// No description provided for @mathExamRetry.
  ///
  /// In en, this message translates to:
  /// **'Retake test'**
  String get mathExamRetry;

  /// No description provided for @mathExamBackToPractice.
  ///
  /// In en, this message translates to:
  /// **'Back to practice'**
  String get mathExamBackToPractice;

  /// No description provided for @mathScreenLockedSnack.
  ///
  /// In en, this message translates to:
  /// **'Screen is locked. Tap Unlock and enter the password.'**
  String get mathScreenLockedSnack;

  /// No description provided for @mathLockMathScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock math screen'**
  String get mathLockMathScreenTitle;

  /// No description provided for @mathPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get mathPasswordHint;

  /// No description provided for @mathUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get mathUnlockTitle;

  /// No description provided for @mathPasswordEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get mathPasswordEntryTitle;

  /// No description provided for @mathDialogLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get mathDialogLock;

  /// No description provided for @mathDialogUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get mathDialogUnlock;

  /// No description provided for @mathDialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get mathDialogOk;

  /// No description provided for @mathWrongPasswordSnack.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Please try again.'**
  String get mathWrongPasswordSnack;

  /// No description provided for @mathExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave math?'**
  String get mathExitTitle;

  /// No description provided for @mathExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to go back?'**
  String get mathExitMessage;

  /// No description provided for @mathExitStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get mathExitStay;

  /// No description provided for @mathExitLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get mathExitLeave;

  /// No description provided for @mathNoQuestion.
  ///
  /// In en, this message translates to:
  /// **'No question available'**
  String get mathNoQuestion;

  /// No description provided for @mathTooltipOpenExam.
  ///
  /// In en, this message translates to:
  /// **'Open test setup'**
  String get mathTooltipOpenExam;

  /// No description provided for @mathTooltipUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get mathTooltipUnlock;

  /// No description provided for @mathTooltipLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get mathTooltipLock;

  /// No description provided for @mathTooltipManageObjects.
  ///
  /// In en, this message translates to:
  /// **'Manage objects'**
  String get mathTooltipManageObjects;

  /// No description provided for @mathExamModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Mode: Test'**
  String get mathExamModeBanner;

  /// No description provided for @mathScoreRunning.
  ///
  /// In en, this message translates to:
  /// **'Score: {score} / {total}'**
  String mathScoreRunning(int score, int total);

  /// No description provided for @mathCompareInstruction.
  ///
  /// In en, this message translates to:
  /// **'Compare and pick the correct sign'**
  String get mathCompareInstruction;

  /// No description provided for @mathCountingQuestionHowMany.
  ///
  /// In en, this message translates to:
  /// **'How many {name}?'**
  String mathCountingQuestionHowMany(String name);

  /// No description provided for @mathSequenceFillMissingHint.
  ///
  /// In en, this message translates to:
  /// **'Fill in the missing number'**
  String get mathSequenceFillMissingHint;

  /// No description provided for @mathSequenceModeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'How should the number line work?'**
  String get mathSequenceModeDialogTitle;

  /// No description provided for @mathSequenceModeConsecutiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Count in order'**
  String get mathSequenceModeConsecutiveTitle;

  /// No description provided for @mathSequenceModeConsecutiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1, 2, 3, 4, 5… — best for beginners'**
  String get mathSequenceModeConsecutiveSubtitle;

  /// No description provided for @mathSequenceModeRandomTitle.
  ///
  /// In en, this message translates to:
  /// **'Mixed steps'**
  String get mathSequenceModeRandomTitle;

  /// No description provided for @mathSequenceModeRandomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Steps of 1, 2, or 3 — like before'**
  String get mathSequenceModeRandomSubtitle;

  /// No description provided for @mathSequenceModeConsecutiveChip.
  ///
  /// In en, this message translates to:
  /// **'Count in order'**
  String get mathSequenceModeConsecutiveChip;

  /// No description provided for @mathSequenceModeRandomChip.
  ///
  /// In en, this message translates to:
  /// **'Mixed steps'**
  String get mathSequenceModeRandomChip;

  /// No description provided for @mathSortInstructionAscending.
  ///
  /// In en, this message translates to:
  /// **'Sort in ascending order'**
  String get mathSortInstructionAscending;

  /// No description provided for @mathSortInstructionDescending.
  ///
  /// In en, this message translates to:
  /// **'Sort in descending order'**
  String get mathSortInstructionDescending;

  /// No description provided for @mathAddSubPickAnswer.
  ///
  /// In en, this message translates to:
  /// **'Pick the correct answer'**
  String get mathAddSubPickAnswer;

  /// No description provided for @mathEntityManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Math objects'**
  String get mathEntityManagerTitle;

  /// No description provided for @mathEntityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Object name'**
  String get mathEntityNameLabel;

  /// No description provided for @mathEntityNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Apple'**
  String get mathEntityNameHint;

  /// No description provided for @mathEntityImageSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Image source'**
  String get mathEntityImageSourceLabel;

  /// No description provided for @mathEntitySourceBase64.
  ///
  /// In en, this message translates to:
  /// **'Pick image on device (base64)'**
  String get mathEntitySourceBase64;

  /// No description provided for @mathEntitySourceUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get mathEntitySourceUrl;

  /// No description provided for @mathEntitySourceVector.
  ///
  /// In en, this message translates to:
  /// **'Default vector'**
  String get mathEntitySourceVector;

  /// No description provided for @mathEntityUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get mathEntityUrlLabel;

  /// No description provided for @mathEntityUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get mathEntityUrlHint;

  /// No description provided for @mathEntityPickFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Pick image on device'**
  String get mathEntityPickFromDevice;

  /// No description provided for @mathEntityVectorShapeLabel.
  ///
  /// In en, this message translates to:
  /// **'Default vector shape'**
  String get mathEntityVectorShapeLabel;

  /// No description provided for @mathEntityShapeCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get mathEntityShapeCircle;

  /// No description provided for @mathEntityShapeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get mathEntityShapeSquare;

  /// No description provided for @mathEntityShapeRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get mathEntityShapeRectangle;

  /// No description provided for @mathEntityShapeTriangle.
  ///
  /// In en, this message translates to:
  /// **'Triangle'**
  String get mathEntityShapeTriangle;

  /// No description provided for @mathEntityShapeStar.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get mathEntityShapeStar;

  /// No description provided for @mathEntityAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add object'**
  String get mathEntityAddButton;

  /// No description provided for @mathEntitySnackNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an object name'**
  String get mathEntitySnackNameRequired;

  /// No description provided for @mathEntitySnackPickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an image from the device'**
  String get mathEntitySnackPickImage;

  /// No description provided for @mathEntitySnackUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an image URL'**
  String get mathEntitySnackUrlRequired;

  /// No description provided for @mathEntitySnackAdded.
  ///
  /// In en, this message translates to:
  /// **'Object added'**
  String get mathEntitySnackAdded;

  /// No description provided for @mathEntityAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add object: {error}'**
  String mathEntityAddFailed(String error);

  /// No description provided for @mathEntitySubtitleVector.
  ///
  /// In en, this message translates to:
  /// **'Vector: {value}'**
  String mathEntitySubtitleVector(String value);

  /// No description provided for @mathEntitySubtitleBase64.
  ///
  /// In en, this message translates to:
  /// **'Image on device (base64)'**
  String get mathEntitySubtitleBase64;

  /// No description provided for @mathEntityDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mathEntityDeleteTooltip;

  /// No description provided for @mathEntityDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this object?'**
  String get mathEntityDeleteConfirmTitle;

  /// No description provided for @mathEntityDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get mathEntityDeleteConfirmBody;

  /// No description provided for @mathEntityDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mathEntityDeleteConfirmAction;

  /// No description provided for @mathEntityDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mathEntityDeleteCancel;

  /// No description provided for @mathSizeCompareOptionLeftBigger.
  ///
  /// In en, this message translates to:
  /// **'Left is bigger'**
  String get mathSizeCompareOptionLeftBigger;

  /// No description provided for @mathSizeCompareOptionRightBigger.
  ///
  /// In en, this message translates to:
  /// **'Right is bigger'**
  String get mathSizeCompareOptionRightBigger;

  /// No description provided for @mathSizeCompareOptionEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get mathSizeCompareOptionEqual;

  /// No description provided for @mathPositionTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get mathPositionTop;

  /// No description provided for @mathPositionBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get mathPositionBottom;

  /// No description provided for @mathPositionLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get mathPositionLeft;

  /// No description provided for @mathPositionRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get mathPositionRight;

  /// No description provided for @mathSameAnswerSame.
  ///
  /// In en, this message translates to:
  /// **'Same'**
  String get mathSameAnswerSame;

  /// No description provided for @mathSameAnswerDifferent.
  ///
  /// In en, this message translates to:
  /// **'Different'**
  String get mathSameAnswerDifferent;

  /// No description provided for @homeSubjectAlphabetTitle.
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get homeSubjectAlphabetTitle;

  /// No description provided for @homeSubjectAlphabetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Letters, sounds & spelling (Grade 1)'**
  String get homeSubjectAlphabetSubtitle;

  /// No description provided for @alphabetScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the alphabet & spelling'**
  String get alphabetScreenTitle;

  /// No description provided for @alphabetScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to listen. Use Spelling to hear syllable-by-syllable blending.'**
  String get alphabetScreenSubtitle;

  /// No description provided for @alphabetListenLetter.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get alphabetListenLetter;

  /// No description provided for @alphabetSpell.
  ///
  /// In en, this message translates to:
  /// **'Spell'**
  String get alphabetSpell;

  /// No description provided for @alphabetTtsError.
  ///
  /// In en, this message translates to:
  /// **'Could not play audio. Check device volume and try again.'**
  String get alphabetTtsError;

  /// No description provided for @alphabetEditCardsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Customize cards'**
  String get alphabetEditCardsTooltip;

  /// No description provided for @alphabetCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Alphabet cards'**
  String get alphabetCatalogTitle;

  /// No description provided for @alphabetCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap a letter to change example text, spelling word, or picture.'**
  String get alphabetCatalogSubtitle;

  /// No description provided for @alphabetEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit: {letter}'**
  String alphabetEditorTitle(String letter);

  /// No description provided for @alphabetEditorExampleVi.
  ///
  /// In en, this message translates to:
  /// **'Example (Vietnamese)'**
  String get alphabetEditorExampleVi;

  /// No description provided for @alphabetEditorExampleEn.
  ///
  /// In en, this message translates to:
  /// **'Example (English)'**
  String get alphabetEditorExampleEn;

  /// No description provided for @alphabetEditorSpell.
  ///
  /// In en, this message translates to:
  /// **'Spelling syllable (Vietnamese)'**
  String get alphabetEditorSpell;

  /// No description provided for @alphabetEditorSpellHint.
  ///
  /// In en, this message translates to:
  /// **'Used for “Spell” — e.g. lá, cá, tre'**
  String get alphabetEditorSpellHint;

  /// No description provided for @alphabetEditorImageSection.
  ///
  /// In en, this message translates to:
  /// **'Illustration'**
  String get alphabetEditorImageSection;

  /// No description provided for @alphabetEditorImageIcon.
  ///
  /// In en, this message translates to:
  /// **'Default icon'**
  String get alphabetEditorImageIcon;

  /// No description provided for @alphabetEditorImageDevice.
  ///
  /// In en, this message translates to:
  /// **'Photo from device'**
  String get alphabetEditorImageDevice;

  /// No description provided for @alphabetEditorImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get alphabetEditorImageUrl;

  /// No description provided for @alphabetEditorUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://…'**
  String get alphabetEditorUrlHint;

  /// No description provided for @alphabetEditorPickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick image'**
  String get alphabetEditorPickImage;

  /// No description provided for @alphabetEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get alphabetEditorSave;

  /// No description provided for @alphabetEditorReset.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get alphabetEditorReset;

  /// No description provided for @alphabetEditorResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults?'**
  String get alphabetEditorResetTitle;

  /// No description provided for @alphabetEditorResetBody.
  ///
  /// In en, this message translates to:
  /// **'This card will use the built-in example and icon again.'**
  String get alphabetEditorResetBody;

  /// No description provided for @alphabetEditorSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get alphabetEditorSaved;

  /// No description provided for @alphabetEditorValidationExample.
  ///
  /// In en, this message translates to:
  /// **'Enter the Vietnamese example'**
  String get alphabetEditorValidationExample;

  /// No description provided for @alphabetEditorValidationSpell.
  ///
  /// In en, this message translates to:
  /// **'Enter the spelling syllable'**
  String get alphabetEditorValidationSpell;

  /// No description provided for @alphabetEditorValidationUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter an image URL'**
  String get alphabetEditorValidationUrl;

  /// No description provided for @alphabetEditorValidationImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an image from the device'**
  String get alphabetEditorValidationImage;

  /// No description provided for @studyTrackingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No study sessions yet. Open a subject and study — times and results will appear here.'**
  String get studyTrackingEmpty;

  /// No description provided for @studyTrackingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get studyTrackingTimeLabel;

  /// No description provided for @studyTrackingStatsLine.
  ///
  /// In en, this message translates to:
  /// **'{total} questions · {correct} correct · {wrong} wrong'**
  String studyTrackingStatsLine(int total, int correct, int wrong);

  /// No description provided for @studyTrackingDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete record'**
  String get studyTrackingDeleteTooltip;

  /// No description provided for @studyTrackingDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get studyTrackingDeleteTitle;

  /// No description provided for @studyTrackingDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This study record will be removed from history.'**
  String get studyTrackingDeleteBody;

  /// No description provided for @studyTrackingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get studyTrackingCancel;

  /// No description provided for @studyTrackingConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get studyTrackingConfirmDelete;

  /// No description provided for @studySessionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Session details'**
  String get studySessionDetailTitle;

  /// No description provided for @studySessionDetailEmptyAttempts.
  ///
  /// In en, this message translates to:
  /// **'No saved question details for this session.'**
  String get studySessionDetailEmptyAttempts;

  /// No description provided for @studySessionDetailQuestionIndex.
  ///
  /// In en, this message translates to:
  /// **'Question {index}'**
  String studySessionDetailQuestionIndex(int index);

  /// No description provided for @studySessionDetailYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get studySessionDetailYourAnswer;

  /// No description provided for @studySessionDetailCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get studySessionDetailCorrectAnswer;

  /// No description provided for @studySessionDetailCorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get studySessionDetailCorrectLabel;

  /// No description provided for @studySessionDetailWrongLabel.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get studySessionDetailWrongLabel;

  /// No description provided for @studySessionDetailActivityType.
  ///
  /// In en, this message translates to:
  /// **'Activity type'**
  String get studySessionDetailActivityType;

  /// No description provided for @studySessionDetailOpenTooltip.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get studySessionDetailOpenTooltip;

  /// No description provided for @studySessionDetailRelationMore.
  ///
  /// In en, this message translates to:
  /// **'Greater (more)'**
  String get studySessionDetailRelationMore;

  /// No description provided for @studySessionDetailRelationLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get studySessionDetailRelationLess;

  /// No description provided for @studySessionDetailRelationEqual.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get studySessionDetailRelationEqual;

  /// No description provided for @studySessionDetailSortAscending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get studySessionDetailSortAscending;

  /// No description provided for @studySessionDetailSortDescending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get studySessionDetailSortDescending;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
