// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ứng dụng học tập';

  @override
  String get homeAppBarTitle => 'Học tập';

  @override
  String get homeTabSubjects => 'Môn học';

  @override
  String get homeTabComingSoon => 'Sắp có';

  @override
  String get homeTabSettings => 'Cài đặt';

  @override
  String get homeTabTracking => 'Theo dõi';

  @override
  String get homePickSubject => 'Chọn môn để bắt đầu';

  @override
  String get homeSubjectReadingTitle => 'Tập đọc';

  @override
  String get homeSubjectReadingSubtitle => 'Đọc và luyện tiếng Việt';

  @override
  String get homeSubjectMathTitle => 'Toán';

  @override
  String get homeSubjectMathSubtitle => 'Toán tư duy';

  @override
  String get homeSubjectLanguageTitle => 'Ngoại ngữ';

  @override
  String get homeSubjectLanguageSubtitle =>
      'Từ điển offline — ưu tiên tiếng Anh';

  @override
  String get languageStudyHubTitle => 'Học ngoại ngữ';

  @override
  String get languageStudyHubPickPair => 'Chọn cặp ngôn ngữ';

  @override
  String get languageStudyPairEnVnTitle => 'Tiếng Anh → Tiếng Việt';

  @override
  String get languageStudyPairEnVnSubtitle => 'Tra cứu từ offline';

  @override
  String get languageStudyPairZhViTitle => 'Tiếng Trung → Tiếng Việt';

  @override
  String get languageStudyPairZhViSubtitle => 'Sẽ bổ sung sau';

  @override
  String get languageStudyPairZhEnTitle => 'Tiếng Trung → Tiếng Anh';

  @override
  String get languageStudyPairZhEnSubtitle => 'Sẽ bổ sung sau';

  @override
  String get languageStudyChipSoon => 'Sắp có';

  @override
  String get languageStudyUnlockTitle => 'Mở khoá';

  @override
  String get languageStudyLockScreenTitle => 'Khoá màn hình này';

  @override
  String get languageStudyExitTitle => 'Thoát học ngoại ngữ?';

  @override
  String get languageStudyExitMessage => 'Bạn sẽ quay lại trang chủ.';

  @override
  String get languageStudyScreenLockedSnack =>
      'Màn hình đang khoá. Bấm biểu tượng khoá và nhập mật khẩu.';

  @override
  String get languageStudyEnViAppBarTitle => 'Tiếng Anh · Tiếng Việt';

  @override
  String get languageStudyPreparingDb => 'Đang chuẩn bị từ điển…';

  @override
  String get languageStudyDbReady => 'Từ điển đã sẵn sàng.';

  @override
  String get languageStudyDbError => 'Không mở được từ điển.';

  @override
  String get languageStudyTryHello => 'Thử: hello';

  @override
  String get languageStudySearchHint => 'Gõ từ tiếng Anh…';

  @override
  String get languageStudyLookupTooltip => 'Tra cứu';

  @override
  String get languageStudyClearSearchTooltip => 'Xoá';

  @override
  String get languageStudyTypeForSuggestions => 'Gõ thêm để xem gợi ý từ.';

  @override
  String get languageStudyNoSuggestions => 'Chưa có từ trùng khớp.';

  @override
  String get languageStudyNoWordFound => 'Không có mục từ điển cho từ này.';

  @override
  String get languageStudyMeaningsHeading => 'Nghĩa';

  @override
  String get languageStudyExampleLabel => 'Ví dụ';

  @override
  String get languageStudySourceLabel => 'Nguồn';

  @override
  String get languageStudyLearn20Button => 'Học 20 từ ngẫu nhiên';

  @override
  String get languageStudyReview20Button => 'Kiểm tra 20 từ đã học';

  @override
  String get languageStudyLearn20AppBar => 'Học · 20 từ';

  @override
  String get languageStudyReview20AppBar => 'Kiểm tra · 20 từ';

  @override
  String get languageStudyReviewEmpty =>
      'Chưa có từ nào đã học. Hãy mở \"Học 20 từ ngẫu nhiên\" trước.';

  @override
  String languageStudyTopicBanner(String topic) {
    return 'Chủ đề: $topic';
  }

  @override
  String get languageStudyTopicNoun => 'Danh từ';

  @override
  String get languageStudyTopicVerb => 'Động từ';

  @override
  String get languageStudyTopicAdjective => 'Tính từ';

  @override
  String get languageStudyTopicAdverb => 'Trạng từ';

  @override
  String get languageStudyTapToListen => 'Chạm thẻ để nghe từ tiếng Anh';

  @override
  String get languageStudyTtsSpeedTitle => 'Tốc độ đọc';

  @override
  String get languageStudyTtsSpeedHint => 'Chậm ← → Nhanh';

  @override
  String languageStudyQuizProgress(int current, int total) {
    return 'Câu $current / $total';
  }

  @override
  String get languageStudyQuizPickMeaning => 'Chọn nghĩa tiếng Việt đúng';

  @override
  String get languageStudyQuizNext => 'Tiếp theo';

  @override
  String get languageStudyQuizFinish => 'Hoàn thành';

  @override
  String get languageStudyQuizDoneTitle => 'Hoàn thành kiểm tra';

  @override
  String languageStudyQuizDoneBody(int correct, int total) {
    return 'Bạn trả lời đúng $correct/$total câu.';
  }

  @override
  String languageStudyLearnedCount(int count) {
    return 'Đã gặp $count từ khi học';
  }

  @override
  String get languageStudyAttribution =>
      'Dữ liệu từ điển: minhqnd (CC BY-SA 4.0) · dict.minhqnd.com';

  @override
  String get homeSoonEnglishTitle => 'Tiếng Anh';

  @override
  String get homeSoonEnglishSubtitle => 'Từ vựng, nghe — đang chuẩn bị';

  @override
  String get homeSoonOtherTitle => 'Môn khác';

  @override
  String get homeSoonOtherSubtitle => 'Sẽ bổ sung theo lộ trình';

  @override
  String get homeChipComingSoon => 'Sắp có';

  @override
  String homeComingSoonSnack(String title) {
    return 'Mục \"$title\" sẽ được thêm sau.';
  }

  @override
  String get settingsLanguageTitle => 'Ngôn ngữ';

  @override
  String get settingsLanguageSubtitle => 'Chọn ngôn ngữ hiển thị ứng dụng';

  @override
  String get settingsLanguageVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageEnglish => 'Tiếng Anh';

  @override
  String get mathListAppBarTitle => 'Danh sách dạng toán tư duy';

  @override
  String get mathGroupNumberCounting => 'Số và đếm';

  @override
  String get mathGroupSimpleOperations => 'Phép tính đơn giản';

  @override
  String get mathGroupGeometrySpace => 'Hình học và không gian';

  @override
  String get mathGroupClassificationLogic => 'Phân loại và logic';

  @override
  String get mathActCountingTitle => 'Đếm số vật, chọn đáp án đúng';

  @override
  String get mathActCountingDesc =>
      'Đếm số lượng vật rồi chọn một trong hai đáp án.';

  @override
  String get mathActCompareTitle => 'So sánh nhiều hơn, ít hơn, bằng nhau';

  @override
  String get mathActCompareDesc => 'Quan sát hai nhóm và chọn quan hệ đúng.';

  @override
  String get mathActSequenceTitle => 'Điền số còn thiếu trong dãy';

  @override
  String get mathActSequenceDesc => 'Ví dụ: 1, 2, ?, 4, 5.';

  @override
  String get mathActSortTitle => 'Sắp xếp số tăng hoặc giảm';

  @override
  String get mathActSortDesc => 'Sắp xếp dãy số theo thứ tự.';

  @override
  String get mathActAddSubTitle => 'Cộng, trừ trong phạm vi 10 và 20';

  @override
  String get mathActAddSubDesc => 'Luyện phép cộng trừ cơ bản.';

  @override
  String get mathActPictureTitle => 'Bài toán có tranh';

  @override
  String get mathActPictureDesc => 'Ví dụ: 3 con gà + 2 con gà = ?';

  @override
  String get mathPictureSumLimitDialogTitle => 'Giới hạn tổng phép cộng';

  @override
  String get mathPictureSumLimitDialogBody =>
      'Mỗi câu có hai nhóm; tổng hai nhóm không vượt quá số này.';

  @override
  String get mathPictureSumLimitLabel => 'Tổng tối đa (ví dụ 10)';

  @override
  String get mathPictureSumLimitInvalid => 'Nhập một số nguyên.';

  @override
  String mathPictureSumLimitOutOfRange(int min, int max) {
    return 'Tổng phải từ $min đến $max.';
  }

  @override
  String get mathPictureAddCountHint =>
      'Đếm tranh từng bên, rồi chọn tổng bên dưới.';

  @override
  String get mathPictureAddLayoutHint =>
      'Đếm từng nhóm, rồi chọn đáp án phía dưới.';

  @override
  String get mathActFillOpTitle => 'Điền dấu +, −, =';

  @override
  String get mathActFillOpDesc => 'Chọn dấu phép tính đúng vào chỗ trống.';

  @override
  String get mathActShapesTitle => 'Nhận biết hình học';

  @override
  String get mathActShapesDesc => 'Tròn, vuông, tam giác, chữ nhật.';

  @override
  String get mathActSizeCompareTitle => 'Phân biệt to nhỏ, cao thấp, dài ngắn';

  @override
  String get mathActSizeCompareDesc => 'Quan sát và chọn mô tả đúng.';

  @override
  String get mathActPositionTitle => 'Nhận biết vị trí';

  @override
  String get mathActPositionDesc => 'Trên, dưới, trái, phải, trong, ngoài.';

  @override
  String get mathActOddOneTitle => 'Tìm vật khác loại';

  @override
  String get mathActOddOneDesc => 'Ví dụ: mèo, chó, ô tô — khác loại?';

  @override
  String get mathActPatternTitle => 'Hoàn thành quy luật';

  @override
  String get mathActPatternDesc => 'Ví dụ: đỏ, xanh, đỏ, xanh, …';

  @override
  String get mathActMatchingTitle => 'Ghép cặp tương ứng';

  @override
  String get mathActMatchingDesc => 'Con vật — thức ăn, đồ vật — công dụng.';

  @override
  String get mathActSameDiffTitle => 'Tìm hình giống hoặc khác nhau';

  @override
  String get mathActSameDiffDesc => 'Quan sát và chọn đáp án phù hợp.';

  @override
  String get mathPlaceholderBody =>
      'Dạng toán này sẽ được bổ sung trong bản cập nhật sau.';

  @override
  String get mathCountingScreenTitle => 'Học toán tư duy';

  @override
  String get mathExamStartTitle => 'Bắt đầu kiểm tra';

  @override
  String get mathExamDurationLabel => 'Thời gian làm';

  @override
  String get mathExamTimePerQuestionLabel => 'Giới hạn mỗi câu';

  @override
  String get mathExamMinutes5 => '5 phút';

  @override
  String get mathExamMinutes10 => '10 phút';

  @override
  String get mathExamMinutes15 => '15 phút';

  @override
  String get mathExamMinutes20 => '20 phút';

  @override
  String get mathExamSeconds30PerQ => '30 giây / câu';

  @override
  String get mathExamSeconds45PerQ => '45 giây / câu';

  @override
  String get mathExamSeconds60PerQ => '60 giây / câu';

  @override
  String get mathExamSeconds90PerQ => '90 giây / câu';

  @override
  String mathExamEstimatedQuestions(int count) {
    return 'Ước tính số câu: $count';
  }

  @override
  String get mathCancel => 'Huỷ';

  @override
  String get mathStart => 'Bắt đầu';

  @override
  String get mathExamResultTitle => 'Kết quả bài kiểm tra';

  @override
  String mathExamScoreColon(int score, int total) {
    return 'Điểm: $score / $total';
  }

  @override
  String mathExamCorrectCount(int n) {
    return 'Đúng: $n câu';
  }

  @override
  String mathExamWrongCount(int n) {
    return 'Sai: $n câu';
  }

  @override
  String get mathExamRetry => 'Làm lại kiểm tra';

  @override
  String get mathExamBackToPractice => 'Về luyện tập';

  @override
  String get mathScreenLockedSnack =>
      'Màn hình đang khoá. Bấm nút mở khoá để nhập mật khẩu.';

  @override
  String get mathLockMathScreenTitle => 'Khoá màn hình toán';

  @override
  String get mathPasswordHint => 'Mật khẩu';

  @override
  String get mathUnlockTitle => 'Mở khoá';

  @override
  String get mathPasswordEntryTitle => 'Nhập mật khẩu';

  @override
  String get mathDialogLock => 'Khoá';

  @override
  String get mathDialogUnlock => 'Mở khoá';

  @override
  String get mathDialogOk => 'OK';

  @override
  String get mathWrongPasswordSnack => 'Sai mật khẩu, vui lòng thử lại.';

  @override
  String get mathExitTitle => 'Thoát toán tư duy?';

  @override
  String get mathExitMessage => 'Bạn có chắc muốn quay lại không?';

  @override
  String get mathExitStay => 'Ở lại';

  @override
  String get mathExitLeave => 'Thoát';

  @override
  String get mathNoQuestion => 'Không có câu hỏi';

  @override
  String get mathTooltipOpenExam => 'Mở màn kiểm tra';

  @override
  String get mathTooltipUnlock => 'Mở khoá';

  @override
  String get mathTooltipLock => 'Khoá';

  @override
  String get mathTooltipManageObjects => 'Quản lý vật';

  @override
  String get mathExamModeBanner => 'Chế độ: Kiểm tra';

  @override
  String mathScoreRunning(int score, int total) {
    return 'Điểm: $score / $total';
  }

  @override
  String get mathCompareInstruction => 'Hãy so sánh và chọn dấu đúng';

  @override
  String mathCountingQuestionHowMany(String name) {
    return 'Có bao nhiêu $name?';
  }

  @override
  String get mathSequenceFillMissingHint => 'Hãy điền số còn thiếu';

  @override
  String get mathSequenceModeDialogTitle => 'Chọn cách học dãy số';

  @override
  String get mathSequenceModeConsecutiveTitle => 'Số liên tục';

  @override
  String get mathSequenceModeConsecutiveSubtitle =>
      '1, 2, 3, 4, 5… — dễ cho bé mới học';

  @override
  String get mathSequenceModeRandomTitle => 'Quy luật ngẫu nhiên';

  @override
  String get mathSequenceModeRandomSubtitle =>
      'Bước nhảy 1, 2 hoặc 3 — như trước đây';

  @override
  String get mathSequenceModeConsecutiveChip => 'Số liên tục';

  @override
  String get mathSequenceModeRandomChip => 'Quy luật ngẫu nhiên';

  @override
  String get mathSortInstructionAscending => 'Hãy sắp xếp theo thứ tự tăng dần';

  @override
  String get mathSortInstructionDescending =>
      'Hãy sắp xếp theo thứ tự giảm dần';

  @override
  String get mathAddSubPickAnswer => 'Hãy chọn đáp án đúng';

  @override
  String get mathEntityManagerTitle => 'Quản lý vật toán';

  @override
  String get mathEntityNameLabel => 'Tên vật';

  @override
  String get mathEntityNameHint => 'Ví dụ: Quả táo';

  @override
  String get mathEntityImageSourceLabel => 'Nguồn ảnh';

  @override
  String get mathEntitySourceBase64 => 'Chọn ảnh từ máy (base64)';

  @override
  String get mathEntitySourceUrl => 'URL ảnh';

  @override
  String get mathEntitySourceVector => 'Vector mặc định';

  @override
  String get mathEntityUrlLabel => 'URL ảnh';

  @override
  String get mathEntityUrlHint => 'https://…';

  @override
  String get mathEntityPickFromDevice => 'Chọn ảnh trong máy';

  @override
  String get mathEntityVectorShapeLabel => 'Hình vector mặc định';

  @override
  String get mathEntityShapeCircle => 'Hình tròn';

  @override
  String get mathEntityShapeSquare => 'Hình vuông';

  @override
  String get mathEntityShapeRectangle => 'Hình chữ nhật';

  @override
  String get mathEntityShapeTriangle => 'Hình tam giác';

  @override
  String get mathEntityShapeStar => 'Hình ngôi sao';

  @override
  String get mathEntityAddButton => 'Thêm vật';

  @override
  String get mathEntitySnackNameRequired => 'Nhập tên vật';

  @override
  String get mathEntitySnackPickImage => 'Hãy chọn ảnh từ máy';

  @override
  String get mathEntitySnackUrlRequired => 'Nhập URL ảnh';

  @override
  String get mathEntitySnackAdded => 'Đã thêm vật';

  @override
  String mathEntityAddFailed(String error) {
    return 'Thêm vật thất bại: $error';
  }

  @override
  String mathEntitySubtitleVector(String value) {
    return 'Vector: $value';
  }

  @override
  String get mathEntitySubtitleBase64 => 'Ảnh trong máy (base64)';

  @override
  String get mathEntityDeleteTooltip => 'Xoá';

  @override
  String get mathEntityDeleteConfirmTitle => 'Xoá vật này?';

  @override
  String get mathEntityDeleteConfirmBody => 'Thao tác này không hoàn tác.';

  @override
  String get mathEntityDeleteConfirmAction => 'Xoá';

  @override
  String get mathEntityDeleteCancel => 'Huỷ';

  @override
  String get mathSizeCompareOptionLeftBigger => 'Bên trái to hơn';

  @override
  String get mathSizeCompareOptionRightBigger => 'Bên phải to hơn';

  @override
  String get mathSizeCompareOptionEqual => 'Bằng nhau';

  @override
  String get mathPositionTop => 'Trên';

  @override
  String get mathPositionBottom => 'Dưới';

  @override
  String get mathPositionLeft => 'Trái';

  @override
  String get mathPositionRight => 'Phải';

  @override
  String get mathSameAnswerSame => 'Giống nhau';

  @override
  String get mathSameAnswerDifferent => 'Khác nhau';

  @override
  String get homeSubjectAlphabetTitle => 'Chữ cái';

  @override
  String get homeSubjectAlphabetSubtitle => 'Làm quen âm, vần, đánh vần lớp 1';

  @override
  String get alphabetScreenTitle => 'Bé học bảng chữ cái & đánh vần';

  @override
  String get alphabetScreenSubtitle =>
      'Chạm thẻ để nghe chữ và ví dụ. Bấm Đánh vần để nghe tách âm theo SGK.';

  @override
  String get alphabetListenLetter => 'Nghe chữ';

  @override
  String get alphabetSpell => 'Đánh vần';

  @override
  String get alphabetTtsError =>
      'Không phát được âm thanh. Hãy kiểm tra âm lượng và thử lại.';

  @override
  String get alphabetEditCardsTooltip => 'Tùy chỉnh thẻ';

  @override
  String get alphabetCatalogTitle => 'Thẻ chữ cái';

  @override
  String get alphabetCatalogSubtitle =>
      'Chạm một chữ để đổi ví dụ, từ đánh vần hoặc ảnh minh hoạ.';

  @override
  String alphabetEditorTitle(String letter) {
    return 'Sửa: $letter';
  }

  @override
  String get alphabetEditorExampleVi => 'Ví dụ (tiếng Việt)';

  @override
  String get alphabetEditorExampleEn => 'Ví dụ (tiếng Anh)';

  @override
  String get alphabetEditorSpell => 'Âm / vần đánh vần (tiếng Việt)';

  @override
  String get alphabetEditorSpellHint =>
      'Dùng cho nút Đánh vần — ví dụ: lá, cá, tre';

  @override
  String get alphabetEditorImageSection => 'Ảnh minh hoạ';

  @override
  String get alphabetEditorImageIcon => 'Biểu tượng mặc định';

  @override
  String get alphabetEditorImageDevice => 'Ảnh trong máy';

  @override
  String get alphabetEditorImageUrl => 'URL ảnh';

  @override
  String get alphabetEditorUrlHint => 'https://…';

  @override
  String get alphabetEditorPickImage => 'Chọn ảnh';

  @override
  String get alphabetEditorSave => 'Lưu';

  @override
  String get alphabetEditorReset => 'Khôi phục mặc định';

  @override
  String get alphabetEditorResetTitle => 'Khôi phục mặc định?';

  @override
  String get alphabetEditorResetBody =>
      'Thẻ này sẽ dùng lại ví dụ và biểu tượng gốc của ứng dụng.';

  @override
  String get alphabetEditorSaved => 'Đã lưu';

  @override
  String get alphabetEditorValidationExample => 'Nhập ví dụ tiếng Việt';

  @override
  String get alphabetEditorValidationSpell => 'Nhập âm/vần đánh vần';

  @override
  String get alphabetEditorValidationUrl => 'Nhập URL ảnh';

  @override
  String get alphabetEditorValidationImage => 'Hãy chọn ảnh trong máy';

  @override
  String get studyTrackingEmpty =>
      'Chưa có phiên học nào. Mở một môn và học — thời gian và kết quả sẽ hiện ở đây.';

  @override
  String get studyTrackingTimeLabel => 'Thời gian';

  @override
  String studyTrackingStatsLine(int total, int correct, int wrong) {
    return '$total câu · $correct đúng · $wrong sai';
  }

  @override
  String get studyTrackingDeleteTooltip => 'Xoá bản ghi';

  @override
  String get studyTrackingDeleteTitle => 'Xoá phiên học này?';

  @override
  String get studyTrackingDeleteBody =>
      'Bản ghi học tập sẽ bị xoá khỏi lịch sử.';

  @override
  String get studyTrackingCancel => 'Huỷ';

  @override
  String get studyTrackingConfirmDelete => 'Xoá';

  @override
  String get studySessionDetailTitle => 'Chi tiết phiên học';

  @override
  String get studySessionDetailEmptyAttempts =>
      'Phiên này chưa lưu chi tiết từng câu.';

  @override
  String studySessionDetailQuestionIndex(int index) {
    return 'Câu $index';
  }

  @override
  String get studySessionDetailYourAnswer => 'Bạn đã chọn';

  @override
  String get studySessionDetailCorrectAnswer => 'Đáp án đúng';

  @override
  String get studySessionDetailCorrectLabel => 'Đúng';

  @override
  String get studySessionDetailWrongLabel => 'Sai';

  @override
  String get studySessionDetailActivityType => 'Dạng bài';

  @override
  String get studySessionDetailOpenTooltip => 'Xem chi tiết';

  @override
  String get studySessionDetailRelationMore => 'Nhiều hơn (>)';

  @override
  String get studySessionDetailRelationLess => 'Ít hơn (<)';

  @override
  String get studySessionDetailRelationEqual => 'Bằng (=)';

  @override
  String get studySessionDetailSortAscending => 'Tăng dần';

  @override
  String get studySessionDetailSortDescending => 'Giảm dần';
}
