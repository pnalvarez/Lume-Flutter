import 'package:flutter/material.dart';

/// [Overlay] above the navigator so toasts inserted with [Overlay.of] stay in
/// front of routes and dialogs pushed on [Navigator].
class AppRootOverlay extends StatefulWidget {
  const AppRootOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<AppRootOverlay> createState() => _AppRootOverlayState();
}

class _AppRootOverlayState extends State<AppRootOverlay> {
  late final OverlayEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = OverlayEntry(builder: (context) => widget.child);
  }

  @override
  void didUpdateWidget(AppRootOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _entry.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(initialEntries: [_entry]);
  }
}
