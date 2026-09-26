import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_bloc.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_body.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_event.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';

@RoutePage()
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<AchievementsBloc>()..add(const AchievementsStarted()),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatefulWidget {
  const _AchievementsView();

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<_AchievementsView>
    with AutoRouteAwareStateMixin<_AchievementsView> {
  void _reload() {
    context.read<AchievementsBloc>().add(const AchievementsStarted());
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<AchievementsBloc>();
    final done = bloc.stream.firstWhere(
      (state) => !state.isRefreshing && !state.isLoading,
    );
    bloc.add(const AchievementsStarted());
    await done;
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    _reload();
  }

  @override
  void didPopNext() {
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AchievementsBloc, AchievementsState>(
      builder: (context, state) {
        return AchievementsBody(
          state: state,
          onRetry: _reload,
          onRefresh: _onRefresh,
        );
      },
    );
  }
}
