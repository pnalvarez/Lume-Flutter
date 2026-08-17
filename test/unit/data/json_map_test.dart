import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/json_map.dart';

void main() {
  test('asJsonMap copies Map with non-String keys', () {
    final json = asJsonMap(<dynamic, dynamic>{'title': 'History'});

    expect(json['title'], 'History');
  });

  test('parseJsonList maps each object with fromJson', () {
    final items = parseJsonList(
      [
        {'id': 1},
        {'id': 2},
      ],
      (json) => json['id'] as int,
    );

    expect(items, [1, 2]);
  });
}
