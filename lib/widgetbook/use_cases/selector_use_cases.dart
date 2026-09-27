import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/selector/selector.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _options = ['História', 'Ciência', 'Cultura', 'Investimentos'];

@widgetbook.UseCase(
  name: 'With chevron',
  type: Selector,
  path: '[Lume]/[Organisms]/Selector',
)
Widget selectorWithChevron(BuildContext context) {
  return const _SelectorPreview(hasChevronDown: true);
}

@widgetbook.UseCase(
  name: 'Without chevron',
  type: Selector,
  path: '[Lume]/[Organisms]/Selector',
)
Widget selectorWithoutChevron(BuildContext context) {
  return const _SelectorPreview(hasChevronDown: false);
}

class _SelectorPreview extends StatefulWidget {
  const _SelectorPreview({required this.hasChevronDown});

  final bool hasChevronDown;

  @override
  State<_SelectorPreview> createState() => _SelectorPreviewState();
}

class _SelectorPreviewState extends State<_SelectorPreview> {
  var _selected = _options.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: Selector(
          bottomsheetTitle: 'Escolha uma categoria',
          selectedOption: _selected,
          hasChevronDown: widget.hasChevronDown,
          options: _options,
          onSelectOption: (option) => setState(() => _selected = option),
        ),
      ),
    );
  }
}
