import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume/layers/presentation/shared/level_up_alert.dart';

/// App-level listener that shows [LevelUpAlert] on the root navigator.
///
/// Sits above every route so screens never subscribe to level-up themselves.
class LevelUpHost extends StatefulWidget {
  const LevelUpHost({
    super.key,
    required this.events,
    required this.navigatorKey,
    required this.child,
  });

  final Stream<LevelUpDomain> events;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<LevelUpHost> createState() => _LevelUpHostState();
}

class _LevelUpHostState extends State<LevelUpHost> {
  StreamSubscription<LevelUpDomain>? _subscription;
  final List<LevelUpDomain> _pending = [];
  var _showing = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.events.listen(_enqueue);
  }

  @override
  void didUpdateWidget(LevelUpHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events == widget.events) return;
    _subscription?.cancel();
    _subscription = widget.events.listen(_enqueue);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _enqueue(LevelUpDomain event) {
    _pending.add(event);
    unawaited(_drain());
  }

  Future<void> _drain() async {
    if (_showing) return;
    _showing = true;
    while (_pending.isNotEmpty && mounted) {
      final event = _pending.removeAt(0);
      final navContext = widget.navigatorKey.currentContext;
      if (navContext == null || !navContext.mounted) {
        _pending.insert(0, event);
        _showing = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(_drain());
        });
        return;
      }
      await showLevelUpDialog(navContext, event);
    }
    _showing = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
