import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_body.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardBloc>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) =>
          previous.goToLogin != current.goToLogin ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showAuthSnackBar(context, state.errorMessage!);
        }
        if (state.goToLogin) {
          context.read<DashboardBloc>().add(const DashboardNavigationHandled());
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: AutoTabsRouter(
        routes: const [HomeRoute(), GamesHubRoute(), ProfileRoute()],
        navigatorObservers: () => [AutoRouteObserver()],
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return DashboardBody(
            selectedIndex: tabsRouter.activeIndex,
            onTabSelected: tabsRouter.setActiveIndex,
            child: child,
          );
        },
      ),
    );
  }
}
