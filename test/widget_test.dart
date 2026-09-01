import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/lume_app.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/app/navigation/auth_guard.dart';
import 'package:lume/app/navigation/recovery_guard.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_bloc.dart';
import 'package:lume/layers/presentation/screens/splash/splash_page.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
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

class _PendingHasSelectedCategories implements IHasSelectedCategories {
  @override
  Future<bool> call({bool forceRefresh = false}) => Completer<bool>().future;
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt
      ..registerFactory<IRestoreSession>(_PendingRestoreSession.new)
      ..registerFactory<IHasSeenOnboarding>(_PendingHasSeenOnboarding.new)
      ..registerFactory<IHasSelectedCategories>(
        _PendingHasSelectedCategories.new,
      )
      ..registerFactory<SplashBloc>(
        () => SplashBloc(
          getIt<IRestoreSession>(),
          getIt<IHasSeenOnboarding>(),
          getIt<IHasSelectedCategories>(),
        ),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('LumeApp starts on the splash logo', (tester) async {
    final session = FakeAuthSessionProvider();
    final router = AppRouter(
      authGuard: AuthGuard(session),
      recoveryGuard: RecoveryGuard(session),
    );

    await tester.pumpWidget(
      LumeApp(router: router, levelUpEvents: const Stream<Never>.empty()),
    );
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(LumeLogo), findsOneWidget);
  });

  testWidgets('AuthScaffold shows brand title and subtitle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: const AuthScaffold(subtitle: 'Entrar', child: Text('form')),
      ),
    );
    await tester.pump();

    expect(find.text(authBrandTitle), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('form'), findsOneWidget);
    expect(find.byType(LumeLogo), findsOneWidget);
    expect(
      tester.widget<LumeLogo>(find.byType(LumeLogo)).variant,
      LumeLogoVariant.surface,
    );
  });
}
