import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/observe_auth_state.dart';
import 'package:lume/layers/domain/usecases/resend_confirmation_email.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';

class _Resend implements IResendConfirmationEmail {
  var callCount = 0;

  @override
  Future<void> call({required String email}) async {
    callCount += 1;
  }
}

class _Observe implements IObserveAuthState {
  _Observe(this.controller);

  final StreamController<AuthSession?> controller;

  @override
  Stream<AuthSession?> call() async* {
    yield null;
    yield* controller.stream;
  }
}

class _HasSelected implements IHasSelectedCategories {
  _HasSelected(this.value);

  final bool value;

  @override
  Future<bool> call({bool forceRefresh = false}) async => value;
}

AuthSession _confirmed() {
  return const AuthSession(
    user: AuthUser(id: '1', email: 'a@b.c', isEmailConfirmed: true),
    isPasswordRecovery: false,
  );
}

void main() {
  late StreamController<AuthSession?> sessions;
  late _Resend resend;

  setUp(() {
    sessions = StreamController<AuthSession?>.broadcast();
    resend = _Resend();
  });

  tearDown(() async {
    await sessions.close();
  });

  blocTest<ConfirmEmailBloc, ConfirmEmailState>(
    'seeds email and keeps waiting until a confirmed session arrives',
    build: () => ConfirmEmailBloc(
      resend,
      _Observe(sessions),
      _HasSelected(false),
    ),
    act: (bloc) async {
      bloc.add(const ConfirmEmailStarted(email: 'a@b.c'));
      await pumpEventQueue();
      sessions.add(_confirmed());
      await pumpEventQueue();
    },
    expect: () => [
      isA<ConfirmEmailState>().having((s) => s.email, 'email', 'a@b.c'),
      isA<ConfirmEmailState>()
          .having(
            (s) => s.destination,
            'destination',
            ConfirmEmailDestination.selectCategory,
          )
          .having((s) => s.notice, 'notice', confirmEmailSuccessNotice),
    ],
  );

  blocTest<ConfirmEmailBloc, ConfirmEmailState>(
    'confirmed session with categories goes home',
    build: () => ConfirmEmailBloc(
      resend,
      _Observe(sessions),
      _HasSelected(true),
    ),
    act: (bloc) async {
      bloc.add(const ConfirmEmailStarted(email: 'a@b.c'));
      await pumpEventQueue();
      sessions.add(_confirmed());
      await pumpEventQueue();
    },
    expect: () => [
      isA<ConfirmEmailState>().having((s) => s.email, 'email', 'a@b.c'),
      isA<ConfirmEmailState>().having(
        (s) => s.destination,
        'destination',
        ConfirmEmailDestination.home,
      ),
    ],
  );

  blocTest<ConfirmEmailBloc, ConfirmEmailState>(
    'resend works while waiting for confirmation',
    build: () => ConfirmEmailBloc(
      resend,
      _Observe(sessions),
      _HasSelected(false),
    ),
    act: (bloc) async {
      bloc.add(const ConfirmEmailStarted(email: 'a@b.c'));
      await pumpEventQueue();
      bloc.add(const ConfirmEmailResendPressed());
      await pumpEventQueue();
    },
    expect: () => [
      isA<ConfirmEmailState>().having((s) => s.email, 'email', 'a@b.c'),
      isA<ConfirmEmailState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<ConfirmEmailState>()
          .having((s) => s.isSubmitting, 'submitting', false)
          .having((s) => s.notice, 'notice', confirmEmailResentNotice),
    ],
    verify: (_) => expect(resend.callCount, 1),
  );
}
