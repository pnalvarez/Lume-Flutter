import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/lume_app.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/app/navigation/auth_guard.dart';
import 'package:lume/app/navigation/recovery_guard.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_page.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

import 'helpers/fake_auth_session_provider.dart';

class _PendingRestoreSession implements IRestoreSession {
  @override
  Future<AuthSession?> call() => Completer<AuthSession?>().future;
}

class _PendingHasSeenOnboarding implements IHasSeenOnboarding {
  @override
  Future<bool> call() => Completer<bool>().future;
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt
      ..registerFactory<IRestoreSession>(_PendingRestoreSession.new)
      ..registerFactoryAsync<IHasSeenOnboarding>(
        () async => _PendingHasSeenOnboarding(),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('LumeApp starts on the splash loader', (tester) async {
    final session = FakeAuthSessionProvider();
    final router = AppRouter(
      authGuard: AuthGuard(session),
      recoveryGuard: RecoveryGuard(session),
    );

    await tester.pumpWidget(LumeApp(router: router));
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(CircularLoader), findsOneWidget);
  });

  testWidgets('AuthScaffold shows brand title and subtitle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: const AuthScaffold(
          subtitle: 'Entrar',
          child: Text('form'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('LUME'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('form'), findsOneWidget);
  });
}
