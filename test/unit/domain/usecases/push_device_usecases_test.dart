import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/register_push_device.dart';
import 'package:lume/layers/domain/usecases/request_push_permission.dart';
import 'package:lume/layers/domain/usecases/unregister_push_device.dart';
import 'package:lume/layers/domain/usecases/watch_push_notification_taps.dart';
import 'package:lume/layers/domain/usecases/watch_push_token_refresh.dart';

import '../../../helpers/fake_push.dart';

void main() {
  late FakePushDeviceRepository repository;

  setUp(() => repository = FakePushDeviceRepository());

  test('RegisterPushDevice delegates to the repository', () async {
    expect(await RegisterPushDevice(repository)(), isTrue);
    expect(repository.registerCalls, 1);
  });

  test('UnregisterPushDevice delegates to the repository', () async {
    await UnregisterPushDevice(repository)();
    expect(repository.unregisterCalls, 1);
  });

  test('RequestPushPermission delegates to the repository', () async {
    expect(await RequestPushPermission(repository)(), isTrue);
    expect(repository.requestCalls, 1);
  });

  test('watch use cases expose the repository streams', () async {
    var refreshes = 0;
    var taps = 0;
    WatchPushTokenRefresh(repository)().listen((_) => refreshes++);
    WatchPushNotificationTaps(repository)().listen((_) => taps++);

    repository.refresh.add(null);
    repository.taps.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(refreshes, 1);
    expect(taps, 1);
  });
}
