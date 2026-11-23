import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';

import '../../../helpers/fake_push.dart';

class _AuthRepository implements IAuthRepository {
  _AuthRepository(this.events);

  final List<String> events;

  @override
  Future<void> signOut() async => events.add('signOut');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('removes the push token before ending the session', () async {
    final push = FakePushDeviceRepository();

    await SignOut(_AuthRepository(push.events), push)();

    expect(push.events, ['unregister', 'signOut']);
  });

  test('still signs out when push cleanup fails', () async {
    final push = FakePushDeviceRepository()..unregisterError = Exception('x');

    await SignOut(_AuthRepository(push.events), push)();

    expect(push.events, ['unregister', 'signOut']);
  });
}
