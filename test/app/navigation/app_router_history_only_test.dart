import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against category/settings routes creeping back into the History-only
/// app router. Reads the source declaration so we do not need AutoRoute codegen
/// in unit tests.
void main() {
  test('app router has no category selection or settings routes', () {
    final routerFile = File('lib/app/navigation/app_router.dart');
    expect(routerFile.existsSync(), isTrue);
    final source = routerFile.readAsStringSync();

    expect(source.contains('SelectCategoryRoute'), isFalse);
    expect(source.contains('/select-category'), isFalse);
    expect(source.contains('SettingsRoute'), isFalse);
    expect(source.contains("path: '/settings'"), isFalse);
    expect(source.contains('PersonalInfoRoute'), isTrue);
    expect(source.contains('HomeRoute'), isTrue);
  });
}
