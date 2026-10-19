import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/utils/arabic_digits.dart';
import 'package:sijilak/core/utils/initials.dart';

void main() {
  group('ArabicDigits', () {
    test('converts Latin digits', () {
      expect('0123456789'.toArabicDigits, '٠١٢٣٤٥٦٧٨٩');
    });

    test('groups Arabic amounts with the Arabic thousands separator', () {
      expect(65000.toArabicAmount, '٦٥٬٠٠٠');
      expect(12.4.toArabicAmount, '١٢');
    });

    test('groups Latin amounts with commas', () {
      expect(1234567.toLatinAmount, '1,234,567');
    });
  });

  group('initialsOf', () {
    test('uses the first letter of the first two words', () {
      expect(initialsOf('مصنع الأغذية الحديثة'), 'م أ');
      expect(initialsOf('Modern Foods Co'), 'M F');
    });

    test('handles single words and blanks', () {
      expect(initialsOf('Sijilak'), 'S');
      expect(initialsOf('   '), '');
    });
  });
}
