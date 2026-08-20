import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/home/home_bloc.dart';
import 'package:lume/layers/presentation/screens/home/home_event.dart';
import 'package:lume/layers/presentation/screens/home/home_state.dart';

class _SignOut implements ISignOut {
  var calls = 0;

  @override
  Future<void> call() async {
    calls += 1;
  }
}

void main() {
  blocTest<HomeBloc, HomeState>(
    'sign out goes to login',
    build: () => HomeBloc(_SignOut()),
    act: (bloc) => bloc.add(const HomeSignOutPressed()),
    expect: () => [
      const HomeState(isSigningOut: true),
      const HomeState(goToLogin: true),
    ],
  );
}
