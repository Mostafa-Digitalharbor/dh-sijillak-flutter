import '../../domain/entities/app_language.dart';

/// Language names are always written in their own language, so they are
/// deliberately not part of the translated strings.
extension AppLanguageLabel on AppLanguage {
  String get nativeName => switch (this) {
    AppLanguage.arabic => 'العربية',
    AppLanguage.english => 'English',
  };
}
