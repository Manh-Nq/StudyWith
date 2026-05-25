/// Phần đọc ngay sau "Chữ " (tiếng Việt) khi bấm Nghe chữ — tên chữ / âm chuẩn dạy phổ thông.
///
/// Phụ âm ghép: [Monkey — Phụ âm ghép & cách phát âm](https://monkey.edu.vn/ba-me-can-biet/giao-duc/hoc-tieng-viet/phu-am-ghep-trong-tieng-viet).
/// Gi: đọc **dờ i** (âm /z/ trong chương trình), không dùng "giờ".
/// Gh: **gờ kép**. K, Q: **cờ**, **cu** theo hướng dẫn cập nhật
/// [Babilala — Bảng chữ cái & phát âm Bộ GD 2025](https://babilala.vn/goc-hoc-tieng-anh/bang-chu-cai-tieng-viet-cach-phat-am-chuan-theo-bo-gd-2025/).
String alphabetListenChuTailVi(String letterDisplay) {
  final String key = letterDisplay.trim();
  const Map<String, String> k = <String, String>{
    // Nguyên âm đơn (ký tự tường minh cho Ă Â Ê Ô Ơ Ư Đ)
    'A': 'a',
    'Ă': 'Á',
    'Â': 'Ớ',
    'E': 'e',
    'Ê': 'Ê',
    'I': 'i',
    'O': 'o',
    'Ô': '\u00F4',
    'Ơ': '\u01A1',
    'U': 'u',
    'Ư': '\u01B0',
    'Y': 'i dài',
    // Phụ âm đơn — tên chữ thường dùng lớp 1
    'B': 'bờ',
    'C': 'xê',
    'D': 'dờ',
    'Đ': 'đê',
    'G': 'gờ',
    'H': 'hờ',
    'K': 'cờ',
    'L': 'lờ',
    'M': 'mờ',
    'N': 'nờ',
    'P': 'pờ',
    'Q': 'cu',
    'R': 'rờ',
    'S': 'ét sì',
    'T': 'tờ',
    'V': 'vê',
    'X': 'ích xì',
    // Phụ âm ghép (bảng Monkey + chỉnh Gh / Gi)
    'Ch': 'chờ',
    'Gh': 'gờ kép',
    'Gi': 'di',
    'Kh': 'khờ',
    'Ng': 'ngờ',
    'Ngh': 'ngờ kép',
    'Nh': 'nhờ',
    'Ph': 'phờ',
    'Qu': 'quờ',
    'Th': 'thờ',
    'Tr': 'trờ',
  };
  final String? hit = k[key];
  if (hit != null) {
    return hit;
  }
  return key.toLowerCase();
}
