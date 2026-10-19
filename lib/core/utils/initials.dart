const _arabicArticle = 'ال';

/// Initials of a display name: the first letter of its first two words,
/// ignoring the Arabic definite article
/// (`مصنع الأغذية الحديثة` -> `م أ`, `Modern Foods` -> `M F`).
String initialsOf(String name, {int maxLetters = 2}) {
  final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  return words
      .take(maxLetters)
      .map((word) {
        final base =
            word.length > _arabicArticle.length &&
                word.startsWith(_arabicArticle)
            ? word.substring(_arabicArticle.length)
            : word;
        return String.fromCharCode(base.runes.first);
      })
      .join(' ');
}
