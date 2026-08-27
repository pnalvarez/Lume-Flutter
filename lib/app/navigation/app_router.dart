import 'package:auto_route/auto_route.dart';
import 'package:lume/app/navigation/auth_guard.dart';
import 'package:lume/app/navigation/recovery_guard.dart';
import 'package:lume/app/navigation/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Tab|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.authGuard, required this.recoveryGuard});

  final AuthGuard authGuard;
  final RecoveryGuard recoveryGuard;

  @override
  List<AutoRouteGuard> get guards => [recoveryGuard];

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: '/', initial: true),
    AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: ConfirmEmailRoute.page, path: '/confirm-email'),
    AutoRoute(page: RecoverPasswordRoute.page, path: '/recover-password'),
    AutoRoute(page: DefinePasswordRoute.page, path: '/define-password'),
    AutoRoute(
      page: SelectCategoryRoute.page,
      path: '/select-category',
      guards: [authGuard],
    ),
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      guards: [authGuard],
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
        AutoRoute(page: GamesHubRoute.page, path: 'games'),
        AutoRoute(page: ProfileRoute.page, path: 'progress'),
      ],
    ),
    AutoRoute(page: TrailDetailRoute.page, path: '/trail/:trailId'),
    AutoRoute(
      page: SubmoduleSessionRoute.page,
      path: '/trail/:trailId/submodule/:submoduleId',
    ),
    AutoRoute(page: GamesRoute.page, path: '/games/play'),
  ];
}
