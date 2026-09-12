import 'package:flutter/material.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Settings hub chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class SettingsBody extends StatelessWidget {
  const SettingsBody({
    super.key,
    required this.onBack,
    required this.onPersonalInfoPressed,
    required this.onCategoriesPressed,
  });

  final VoidCallback onBack;
  final VoidCallback onPersonalInfoPressed;
  final VoidCallback onCategoriesPressed;

  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PageHeader(
        title: settingsTitle,
        onBack: onBack,
        titleLayout: PageHeaderTitleLayout.stacked,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacings.xl2,
                AppSpacings.l,
                AppSpacings.xl2,
                AppSpacings.l,
              ),
              children: [
                ListItem(
                  trait: ListItemTrait.neutral,
                  onTap: onPersonalInfoPressed,
                  input: IconTitleDescriptionInput(
                    leadingIcon: Icons.person_outline_rounded,
                    leadingIconColor: cs.primary,
                    title: settingsPersonalInfoTitle,
                    description: settingsPersonalInfoDescription,
                  ),
                ),
                const SizedBox(height: AppSpacings.m),
                ListItem(
                  trait: ListItemTrait.neutral,
                  onTap: onCategoriesPressed,
                  input: IconTitleDescriptionInput(
                    leadingIcon: Icons.category_outlined,
                    leadingIconColor: cs.primary,
                    title: settingsCategoriesTitle,
                    description: settingsCategoriesDescription,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
