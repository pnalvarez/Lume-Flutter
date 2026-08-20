import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_bloc.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_event.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

@RoutePage()
class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<SelectCategoryBloc>()..add(const SelectCategoryStarted()),
      child: const _SelectCategoryView(),
    );
  }
}

class _SelectCategoryView extends StatelessWidget {
  const _SelectCategoryView();

  static const double _maxWidth = 400;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            context.router.replace(const HomeRoute());
          case SelectCategoryDestination.login:
            context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxWidth),
              child: BlocBuilder<SelectCategoryBloc, SelectCategoryState>(
                builder: (context, state) {
                  if (state.status == SelectCategoryStatus.loading) {
                    return const Center(child: CircularLoader());
                  }

                  if (state.status == SelectCategoryStatus.error) {
                    return Padding(
                      padding: const EdgeInsets.all(AppSpacings.xl2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? selectCategoryLoadError,
                            textAlign: TextAlign.center,
                            style: typ.body3Light.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacings.l),
                          LumeButton(
                            label: selectCategoryRetry,
                            type: LumeButtonType.outlined,
                            onPressed: () {
                              context.read<SelectCategoryBloc>().add(
                                const SelectCategoryStarted(),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.xl2,
                      vertical: AppSpacings.l,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacings.l),
                        const Center(
                          child: LumeLogo(
                            size: 72,
                            variant: LumeLogoVariant.surface,
                          ),
                        ),
                        const SizedBox(height: AppSpacings.m),
                        Text(
                          authBrandTitle,
                          textAlign: TextAlign.center,
                          style: typ.headlineL.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacings.xl2),
                        Text(
                          selectCategoryTitle,
                          style: typ.headlineM.copyWith(color: cs.onSurface),
                        ),
                        const SizedBox(height: AppSpacings.s),
                        Text(
                          selectCategorySubtitle,
                          style: typ.body3Light.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacings.l),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SelectableChipGroup<int>(
                              options: [
                                for (final category in state.categories)
                                  SelectableChipOption(
                                    id: category.id,
                                    label: category.name,
                                  ),
                              ],
                              selectedIds: state.selectedIds,
                              onToggle: (id) {
                                context.read<SelectCategoryBloc>().add(
                                  SelectCategoryToggled(id),
                                );
                              },
                              selectAllLabel: selectCategorySelectAll,
                              onSelectAllToggled: () {
                                context.read<SelectCategoryBloc>().add(
                                  const SelectCategorySelectAllToggled(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacings.l),
                        LumeButton(
                          label: selectCategoryCta,
                          size: LumeButtonSize.lg,
                          isExpanded: true,
                          isLoading: state.isSaving,
                          isEnabled: state.canSubmit,
                          onPressed: () {
                            context.read<SelectCategoryBloc>().add(
                              const SelectCategorySubmitted(),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
