import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/presentation/shared/achievement_snack_bar.dart';

/// App-level listener that shows achievement unlock toasts on the root overlay.
///
/// Sits above every route so screens never subscribe to unlocks themselves.
/// Multiple unlocks are queued and shown sequentially.
class AchievementUnlockHost extends StatefulWidget {
  const AchievementUnlockHost({
    super.key,
    required this.events,
    required this.navigatorKey,
    required this.child,
    this.toastDuration = const Duration(seconds: 4),
  });

  final Stream<AchievementUnlockDomain> events;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  /// How long each toast stays visible before the next queued unlock shows.
  ///
  /// Matches [showLumeSnackBar]'s default duration.
  final Duration toastDuration;

  @override
  State<AchievementUnlockHost> createState() => _AchievementUnlockHostState();
}

class _AchievementUnlockHostState extends State<AchievementUnlockHost> {
  StreamSubscription<AchievementUnlockDomain>? _subscription;
  final List<AchievementUnlockDomain> _pending = [];
  var _showing = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.events.listen(_enqueue);
  }

  @override
  void didUpdateWidget(AchievementUnlockHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events == widget.events) return;
    _subscription?.cancel();
    _subscription = widget.events.listen(_enqueue);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pending.clear();
    super.dispose();
  }

  void _enqueue(AchievementUnlockDomain event) {
    if (event.name.trim().isEmpty) return;
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
      showAchievementUnlockedSnackBar(navContext, event.name);
      await Future<void>.delayed(widget.toastDuration);
    }
    _showing = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
