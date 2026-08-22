import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';

class _SignOut implements ISignOut {
  var calls = 0;

  @override
  Future<void> call() async {
    calls += 1;
  }
}

void main() {
  blocTest<DashboardBloc, DashboardState>(
    'sign out goes to login',
    build: () => DashboardBloc(_SignOut()),
    act: (bloc) => bloc.add(const DashboardSignOutPressed()),
    expect: () => [
      const DashboardState(isSigningOut: true),
      const DashboardState(goToLogin: true),
    ],
  );
}
