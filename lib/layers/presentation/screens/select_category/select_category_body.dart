import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Select-category chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class SelectCategoryBody extends StatelessWidget {
  const SelectCategoryBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onToggle,
    required this.onSelectAllToggled,
    required this.onSubmit,
    this.onBack,
  });

  final SelectCategoryState state;
  final VoidCallback onRetry;
  final ValueChanged<int> onToggle;
  final VoidCallback onSelectAllToggled;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;

  static const double _maxWidth = 400;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final showBack = state.isProfileEntry && onBack != null;
    final isLoading = state.status == SelectCategoryStatus.loading;
    final chipCategories = state.categories.isNotEmpty
        ? state.categories
        : [
            for (var i = 0; i < selectCategoryLoadingChipLabels.length; i++)
              CategoryDomain(id: i, name: selectCategoryLoadingChipLabels[i]),
          ];

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: showBack
          ? PageHeader(
              title: selectCategoryTitle,
              onBack: onBack,
              titleLayout: PageHeaderTitleLayout.stacked,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: switch (state.status) {
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
              SelectCategoryStatus.loading ||
              SelectCategoryStatus.ready => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.xl2,
                  vertical: AppSpacings.l,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!state.isProfileEntry) ...[
                      Text(
                        selectCategoryTitle,
                        style: typ.headlineM.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: AppSpacings.s),
                    ],
                    DisplayAsLoader(
                      enabled: isLoading,
                      borderRadius: BorderRadius.circular(AppRadius.s),
                      child: Text(
                        selectCategorySubtitle,
                        style: typ.body3Light.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacings.l),
                    Expanded(
                      child: SingleChildScrollView(
                        child: isLoading
                            ? _LoadingChipGroup(categories: chipCategories)
                            : SelectableChipGroup<int>(
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
                      label: state.ctaLabel,
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

class _LoadingChipGroup extends StatelessWidget {
  const _LoadingChipGroup({required this.categories});

  final List<CategoryDomain> categories;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacings.s,
          runSpacing: AppSpacings.s,
          children: [
            for (final category in categories)
              DisplayAsLoader(
                borderRadius: BorderRadius.circular(AppRadius.full(32)),
                child: SelectableChip(
                  label: category.name,
                  selected: false,
                  onPressed: () {},
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacings.l),
        DisplayAsLoader(
          borderRadius: BorderRadius.circular(AppRadius.s),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: false,
                  onChanged: (_) {},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: AppSpacings.xs),
              Expanded(
                child: Text(
                  selectCategorySelectAll,
                  style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
