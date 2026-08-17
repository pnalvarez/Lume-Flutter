import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Brand & Semantic', type: _ColorCatalog)
Widget colorBrandAndSemantic(BuildContext context) =>
    const _ColorCatalog(group: 'Brand & Semantic');

@widgetbook.UseCase(name: 'Extra & Spectrum', type: _ColorCatalog)
Widget colorExtra(BuildContext context) =>
    const _ColorCatalog(group: 'Extra & Spectrum');

// ---------------------------------------------------------------------------

class _ColorCatalog extends StatelessWidget {
  final String group;
  const _ColorCatalog({required this.group});

  @override
  Widget build(BuildContext context) {
    final swatches = switch (group) {
      'Extra & Spectrum' => _extraSwatches,
      _ => _brandSwatches,
    };

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: swatches
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ColorSwatch(name: s.$1, color: s.$2),
              ),
            )
            .toList(),
      ),
    );
  }

  static final _brandSwatches = <(String, Color)>[
    ('Primary', AppColors.Primary.primary),
    ('Primary Container', AppColors.Primary.primaryContainer),
    ('Secondary', AppColors.Secondary.secondary),
    ('Secondary Container', AppColors.Secondary.secondaryContainer),
    ('Accent', AppColors.Accent.accent),
    ('Accent Light', AppColors.Accent.accentLight),
    ('Success', AppColors.Success.success),
    ('Success Container', AppColors.Success.successContainer),
    ('Error', AppColors.Error.error),
    ('Error Container', AppColors.Error.errorContainer),
    ('Surface', AppColors.Surface.surface),
    ('Surface Low', AppColors.Surface.surfaceContainerLow),
    ('Outline', AppColors.Outline.outline),
    ('Outline Variant', AppColors.Outline.outlineVariant),
  ];

  static final _extraSwatches = <(String, Color)>[
    ('Purple', AppColors.Extra.purple),
    ('Purple Light', AppColors.Extra.purpleLight),
    ('Lavender', AppColors.Extra.lavender),
    ('Lavender Light', AppColors.Extra.lavenderLight),
    ('Lavender Dark', AppColors.Extra.lavenderDark),
    ('Pink', AppColors.Extra.pink),
    ('Pink Light', AppColors.Extra.pinkLight),
    ('Teal', AppColors.Extra.teal),
    ('Teal Light', AppColors.Extra.tealLight),
    ('Slate', AppColors.Extra.slate),
    ('Mint', AppColors.Extra.mint),
    ('Sky', AppColors.Extra.sky),
    ('Violet', AppColors.Extra.violet),
    ('Amber', AppColors.Extra.amber),
    ('Rose', AppColors.Extra.rose),
  ];
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;
  const _ColorSwatch({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    final onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black87
            : Colors.white;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: TextStyle(color: onColor, fontWeight: FontWeight.w600)),
          Text(hex, style: TextStyle(color: onColor, fontSize: 12)),
        ],
      ),
    );
  }
}
