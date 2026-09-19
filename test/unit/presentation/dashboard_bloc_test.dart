import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import '../../helpers/fake_analytics.dart';

class _SignOut implements ISignOut {
  var calls = 0;

  @override
  Future<void> call() async {
    calls += 1;
  }
}

void main() {
  test('sign out goes to login and clears analytics user id', () async {
    final signOut = _SignOut();
    final analytics = FakeAnalytics();
    final bloc = DashboardBloc(signOut, analytics);
    bloc.add(const DashboardSignOutPressed());
    await expectLater(
      bloc.stream,
      emitsInOrder([
        const DashboardState(isSigningOut: true),
        const DashboardState(goToLogin: true),
      ]),
    );
    expect(signOut.calls, 1);
    expect(analytics.userIds, [null]);
    await bloc.close();
  });

  blocTest<DashboardBloc, DashboardState>(
    'sign out goes to login',
    build: () => DashboardBloc(_SignOut(), FakeAnalytics()),
    act: (bloc) => bloc.add(const DashboardSignOutPressed()),
    expect: () => [
      const DashboardState(isSigningOut: true),
      const DashboardState(goToLogin: true),
    ],
  );
}
