import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_body.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_event.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';

@RoutePage()
class TrailDetailPage extends StatelessWidget {
  const TrailDetailPage({super.key, required this.trailId});

  final int trailId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<TrailDetailBloc>()..add(TrailDetailStarted(trailId: trailId)),
      child: _TrailDetailView(trailId: trailId),
    );
  }
}

class _TrailDetailView extends StatelessWidget {
  const _TrailDetailView({required this.trailId});

  final int trailId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrailDetailBloc, TrailDetailState>(
          listenWhen: (previous, current) =>
              previous.selectedSubmoduleId != current.selectedSubmoduleId,
          listener: (context, state) async {
            final submoduleId = state.selectedSubmoduleId;
            if (submoduleId == null) return;
            context.read<TrailDetailBloc>().add(
              const TrailDetailNavigationHandled(),
            );
            await context.router.push(
              SubmoduleSessionRoute(
                trailId: state.trailId,
                submoduleId: submoduleId,
              ),
            );
            if (!context.mounted) return;
            context.read<TrailDetailBloc>().add(
              TrailDetailStarted(trailId: trailId, forceRefresh: true),
            );
          },
        ),
        BlocListener<TrailDetailBloc, TrailDetailState>(
          listenWhen: (previous, current) => previous.goBack != current.goBack,
          listener: (context, state) {
            if (!state.goBack) return;
            context.read<TrailDetailBloc>().add(
              const TrailDetailNavigationHandled(),
            );
            context.router.maybePop();
          },
        ),
      ],
      child: BlocBuilder<TrailDetailBloc, TrailDetailState>(
        builder: (context, state) {
          return TrailDetailBody(
            state: state,
            onBack: () {
              context.read<TrailDetailBloc>().add(
                const TrailDetailBackPressed(),
              );
            },
            onRetry: () {
              context.read<TrailDetailBloc>().add(
                TrailDetailStarted(trailId: trailId, forceRefresh: true),
              );
            },
            onSubmodulePressed: (submoduleId) {
              context.read<TrailDetailBloc>().add(
                TrailDetailSubmodulePressed(submoduleId),
              );
            },
          );
        },
      ),
    );
  }
}
