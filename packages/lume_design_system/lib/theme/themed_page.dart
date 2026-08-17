import 'package:lume_design_system/theme/lume_theme.dart';
import 'package:flutter/material.dart';

/// Wraps [child] in the Lume light theme with a [Material] surface and [SafeArea].
///
/// Useful in Widgetbook frames and as a quick wrapper during development.
class LumeThemedPage extends StatelessWidget {
  final Widget child;
  final bool useDarkTheme;

  const LumeThemedPage({
    super.key,
    required this.child,
    this.useDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = useDarkTheme ? lumeDarkTheme() : lumeLightTheme();
    return Theme(
      data: theme,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(child: child),
      ),
    );
  }
}
