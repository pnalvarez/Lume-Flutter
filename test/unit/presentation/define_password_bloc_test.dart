import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/clear_password_recovery.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/domain/usecases/update_password.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_bloc.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_state.dart';

class _Restore implements IRestoreSession {
  _Restore(this.session);

  final AuthSession? session;

  @override
  Future<AuthSession?> call() async => session;
}

class _Update implements IUpdatePassword {
  var calls = 0;

  @override
  Future<void> call({required String password}) async {
    calls += 1;
  }
}

class _Clear implements IClearPasswordRecovery {
  var calls = 0;

  @override
  void call() {
    calls += 1;
  }
}

void main() {
  const session = AuthSession(
    user: AuthUser(id: '1', email: 'a@b.c', isEmailConfirmed: true),
    isPasswordRecovery: true,
  );

  blocTest<DefinePasswordBloc, DefinePasswordState>(
    'starts ready when a recovery session exists',
    build: () => DefinePasswordBloc(
      restoreSession: _Restore(session),
      updatePassword: _Update(),
      clearPasswordRecovery: _Clear(),
    ),
    act: (bloc) => bloc.add(const DefinePasswordStarted()),
    expect: () => [
      isA<DefinePasswordState>().having(
        (s) => s.status,
        'status',
        DefinePasswordStatus.ready,
      ),
    ],
  );

  blocTest<DefinePasswordBloc, DefinePasswordState>(
    'starts invalid when there is no session',
    build: () => DefinePasswordBloc(
      restoreSession: _Restore(null),
      updatePassword: _Update(),
      clearPasswordRecovery: _Clear(),
    ),
    act: (bloc) => bloc.add(const DefinePasswordStarted()),
    expect: () => [
      isA<DefinePasswordState>().having(
        (s) => s.status,
        'status',
        DefinePasswordStatus.invalid,
      ),
    ],
  );

  blocTest<DefinePasswordBloc, DefinePasswordState>(
    'submit updates the password and goes home',
    build: () => DefinePasswordBloc(
      restoreSession: _Restore(session),
      updatePassword: _Update(),
      clearPasswordRecovery: _Clear(),
    ),
    seed: () => const DefinePasswordState(
      status: DefinePasswordStatus.ready,
      password: 'secret1',
      confirmation: 'secret1',
    ),
    act: (bloc) => bloc.add(const DefinePasswordSubmitted()),
    expect: () => [
      isA<DefinePasswordState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<DefinePasswordState>().having(
        (s) => s.destination,
        'destination',
        DefinePasswordDestination.home,
      ),
    ],
  );
}
