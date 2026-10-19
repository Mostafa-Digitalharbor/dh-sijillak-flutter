import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/features/auth/presentation/utils/phone_mask.dart';

void main() {
  group('maskPhone', () {
    test('keeps 3 leading and 2 trailing digits', () {
      expect(maskPhone('500000045'), '050 ••• ••45');
    });

    test('accepts the national zero, spaces and Arabic-Indic digits', () {
      expect(maskPhone('0500000045'), '050 ••• ••45');
      expect(maskPhone('50 000 0045'), '050 ••• ••45');
      expect(maskPhone('٥٠ ٠٠٠ ٠٠٤٥'), '050 ••• ••45');
    });

    test('empty stays empty', () => expect(maskPhone(''), ''));

    test('numbers too short to hide anything are shown as digits', () {
      expect(maskPhone('50'), '050');
    });
  });
}
