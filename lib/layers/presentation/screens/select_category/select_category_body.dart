import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Select-category chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class SelectCategoryBody extends StatelessWidget {
  const SelectCategoryBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onToggle,
    required this.onSelectAllToggled,
    required this.onSubmit,
  });

  final SelectCategoryState state;
  final VoidCallback onRetry;
  final ValueChanged<int> onToggle;
  final VoidCallback onSelectAllToggled;
  final VoidCallback onSubmit;

  static const double _maxWidth = 400;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: switch (state.status) {
              SelectCategoryStatus.loading => const Center(
                child: CircularLoader(),
              ),
              SelectCategoryStatus.error => Padding(
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
                      onPressed: onRetry,
                    ),
                  ],
                ),
              ),
              SelectCategoryStatus.ready => Padding(
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
                          onToggle: onToggle,
                          selectAllLabel: selectCategorySelectAll,
                          onSelectAllToggled: onSelectAllToggled,
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
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}
