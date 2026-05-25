enum AlphabetOverrideImageKind {
  icon,
  base64,
  url;

  static AlphabetOverrideImageKind parse(String raw) {
    switch (raw) {
      case 'base64':
        return AlphabetOverrideImageKind.base64;
      case 'url':
        return AlphabetOverrideImageKind.url;
      default:
        return AlphabetOverrideImageKind.icon;
    }
  }

  String get wireValue {
    switch (this) {
      case AlphabetOverrideImageKind.icon:
        return 'icon';
      case AlphabetOverrideImageKind.base64:
        return 'base64';
      case AlphabetOverrideImageKind.url:
        return 'url';
    }
  }
}
