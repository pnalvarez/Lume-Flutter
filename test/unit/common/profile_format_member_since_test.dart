import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/profile_strings.dart';

void main() {
  group('profileFormatMemberSince', () {
    test('formats as zero-padded dd/mm/yyyy', () {
      expect(profileFormatMemberSince(DateTime(2026, 8, 1)), '01/08/2026');
      expect(profileFormatMemberSince(DateTime(2026, 12, 31)), '31/12/2026');
    });

    test('returns null for null input', () {
      expect(profileFormatMemberSince(null), isNull);
    });
  });

  group('profileMemberSince', () {
    test('renders date or em dash', () {
      expect(profileMemberSince('01/08/2026'), 'Membro desde 01/08/2026');
      expect(profileMemberSince(null), 'Membro desde —');
    });
  });
}
