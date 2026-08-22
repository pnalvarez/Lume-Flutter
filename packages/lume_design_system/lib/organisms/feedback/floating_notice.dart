import 'package:lume_design_system/molecules/badges/amount_badge.dart';
import 'package:flutter/material.dart';

/// Floating notice aligned to the top (toast-style).
///
/// Fully parametric — typically wraps an [AmountBadge] or any child.
/// No entrance animation (avoids Tween rebuild loops).
class FloatingNotice extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const FloatingNotice({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  /// Convenience constructor for amount-style notices.
  factory FloatingNotice.amount({
    Key? key,
    required String text,
    String? secondaryText,
    IconData? icon,
    Color? accentColor,
    Alignment alignment = Alignment.topCenter,
  }) {
    return FloatingNotice(
      key: key,
      alignment: alignment,
      child: AmountBadge(
        text: text,
        secondaryText: secondaryText,
        icon: icon ?? Icons.bolt_rounded,
        accentColor: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
