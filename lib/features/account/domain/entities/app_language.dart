/// A language the app can be shown in.
enum AppLanguage {
  arabic('ar'),
  english('en');

  const AppLanguage(this.code);

  /// ISO 639-1 code, also the persisted value.
  final String code;

  /// The language with [code], or null when unsupported.
  static AppLanguage? fromCode(String? code) {
    for (final language in values) {
      if (language.code == code) return language;
    }
    return null;
  }
}
