import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/nullable_date_time_converter.dart';

void main() {
  const converter = NullableDateTimeConverter();

  test('parses ISO-8601 strings', () {
    expect(
      converter.fromJson('2026-08-01T12:00:00Z'),
      DateTime.utc(2026, 8, 1, 12),
    );
  });

  test('returns null for null, empty, and invalid values', () {
    expect(converter.fromJson(null), isNull);
    expect(converter.fromJson(''), isNull);
    expect(converter.fromJson('   '), isNull);
    expect(converter.fromJson('not-a-date'), isNull);
    expect(converter.fromJson(42), isNull);
  });

  test('passes through DateTime values', () {
    final value = DateTime.utc(2026, 3, 4);
    expect(converter.fromJson(value), value);
  });

  test('serializes to ISO-8601 or null', () {
    expect(converter.toJson(null), isNull);
    expect(
      converter.toJson(DateTime.utc(2026, 8, 1, 12)),
      '2026-08-01T12:00:00.000Z',
    );
  });
}
