import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_bloc.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_body.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_event.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

export 'package:lume/layers/presentation/screens/select_category/select_category_state.dart'
    show SelectCategoryEntry;

@RoutePage()
class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({
    super.key,
    this.entry = SelectCategoryEntry.onboarding,
  });

  final SelectCategoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SelectCategoryBloc>()..add(SelectCategoryStarted(entry: entry)),
      child: _SelectCategoryView(entry: entry),
    );
  }
}

class _SelectCategoryView extends StatelessWidget {
  const _SelectCategoryView({required this.entry});

  final SelectCategoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectCategoryBloc, SelectCategoryState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.errorMessage != current.errorMessage ||
          previous.notice != current.notice,
      listener: (context, state) {
        if (state.notice != null) {
          showAuthSnackBar(context, state.notice!, isError: false);
        }
        if (state.errorMessage != null && state.destination == null) {
          showAuthSnackBar(context, state.errorMessage!);
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<SelectCategoryBloc>().add(
          const SelectCategoryNavigationHandled(),
        );
        switch (destination) {
          case SelectCategoryDestination.home:
            context.router.replace(const DashboardRoute());
          case SelectCategoryDestination.login:
            context.router.replaceAll([const LoginRoute()]);
          case SelectCategoryDestination.pop:
            context.router.maybePop();
        }
      },
      child: BlocBuilder<SelectCategoryBloc, SelectCategoryState>(
        builder: (context, state) {
          return SelectCategoryBody(
            state: state,
            onRetry: () {
              context.read<SelectCategoryBloc>().add(
                SelectCategoryStarted(entry: entry),
              );
            },
            onToggle: (id) {
              context.read<SelectCategoryBloc>().add(SelectCategoryToggled(id));
            },
            onSelectAllToggled: () {
              context.read<SelectCategoryBloc>().add(
                const SelectCategorySelectAllToggled(),
              );
            },
            onSubmit: () {
              context.read<SelectCategoryBloc>().add(
                const SelectCategorySubmitted(),
              );
            },
            onBack: state.isProfileEntry
                ? () {
                    context.router.maybePop();
                  }
                : null,
          );
        },
      ),
    );
  }
}
