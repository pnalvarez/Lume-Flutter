// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_page.dart'
    as _i1;
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_page.dart'
    as _i3;
import 'package:lume/layers/presentation/screens/auth/login/login_page.dart'
    as _i6;
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_page.dart'
    as _i9;
import 'package:lume/layers/presentation/screens/dashboard/dashboard_page.dart'
    as _i2;
import 'package:lume/layers/presentation/screens/games/games_page.dart' as _i4;
import 'package:lume/layers/presentation/screens/home/home_page.dart' as _i5;
import 'package:lume/layers/presentation/screens/onboarding/onboarding_page.dart'
    as _i7;
import 'package:lume/layers/presentation/screens/progress/progress_page.dart'
    as _i8;
import 'package:lume/layers/presentation/screens/select_category/select_category_page.dart'
    as _i10;
import 'package:lume/layers/presentation/screens/splash/splash_page.dart'
    as _i11;

/// generated route for
/// [_i1.ConfirmEmailPage]
class ConfirmEmailRoute extends _i12.PageRouteInfo<ConfirmEmailRouteArgs> {
  ConfirmEmailRoute({
    _i13.Key? key,
    String email = '',
    List<_i12.PageRouteInfo>? children,
  }) : super(
         ConfirmEmailRoute.name,
         args: ConfirmEmailRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'ConfirmEmailRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConfirmEmailRouteArgs>(
        orElse: () => const ConfirmEmailRouteArgs(),
      );
      return _i1.ConfirmEmailPage(key: args.key, email: args.email);
    },
  );
}

class ConfirmEmailRouteArgs {
  const ConfirmEmailRouteArgs({this.key, this.email = ''});

  final _i13.Key? key;

  final String email;

  @override
  String toString() {
    return 'ConfirmEmailRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConfirmEmailRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [_i2.DashboardPage]
class DashboardRoute extends _i12.PageRouteInfo<void> {
  const DashboardRoute({List<_i12.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashboardPage();
    },
  );
}

/// generated route for
/// [_i3.DefinePasswordPage]
class DefinePasswordRoute extends _i12.PageRouteInfo<void> {
  const DefinePasswordRoute({List<_i12.PageRouteInfo>? children})
    : super(DefinePasswordRoute.name, initialChildren: children);

  static const String name = 'DefinePasswordRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.DefinePasswordPage();
    },
  );
}

/// generated route for
/// [_i4.GamesPage]
class GamesRoute extends _i12.PageRouteInfo<void> {
  const GamesRoute({List<_i12.PageRouteInfo>? children})
    : super(GamesRoute.name, initialChildren: children);

  static const String name = 'GamesRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i4.GamesPage();
    },
  );
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomePage();
    },
  );
}

/// generated route for
/// [_i6.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginPage();
    },
  );
}

/// generated route for
/// [_i7.OnboardingPage]
class OnboardingRoute extends _i12.PageRouteInfo<void> {
  const OnboardingRoute({List<_i12.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i8.ProgressPage]
class ProgressRoute extends _i12.PageRouteInfo<void> {
  const ProgressRoute({List<_i12.PageRouteInfo>? children})
    : super(ProgressRoute.name, initialChildren: children);

  static const String name = 'ProgressRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.ProgressPage();
    },
  );
}

/// generated route for
/// [_i9.RecoverPasswordPage]
class RecoverPasswordRoute extends _i12.PageRouteInfo<void> {
  const RecoverPasswordRoute({List<_i12.PageRouteInfo>? children})
    : super(RecoverPasswordRoute.name, initialChildren: children);

  static const String name = 'RecoverPasswordRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.RecoverPasswordPage();
    },
  );
}

/// generated route for
/// [_i10.SelectCategoryPage]
class SelectCategoryRoute extends _i12.PageRouteInfo<void> {
  const SelectCategoryRoute({List<_i12.PageRouteInfo>? children})
    : super(SelectCategoryRoute.name, initialChildren: children);

  static const String name = 'SelectCategoryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.SelectCategoryPage();
    },
  );
}

/// generated route for
/// [_i11.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.SplashPage();
    },
  );
}
