import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';

/// App-level listener that shows achievement unlock toasts above every route.
///
/// Inserts into an ancestor [Overlay] (see [AppRootOverlay]) so dialogs and
/// routes pushed on the root navigator stay underneath. Uses a dedicated
/// [OverlayEntry] (not [showLumeSnackBar]) so XP toasts in the shared snackbar
/// slot cannot dismiss or replace an unlock toast.
///
/// Multiple unlocks are queued and shown sequentially. Sign-out and user
/// switch clear the queue and dismiss any visible unlock toast. Token refresh
/// (same user id) does not.
class AchievementUnlockHost extends StatefulWidget {
  const AchievementUnlockHost({
    super.key,
    required this.events,
    required this.authSessionChanges,
    required this.authUserId,
    required this.child,
    this.toastDuration = const Duration(seconds: 4),
  });

  final Stream<AchievementUnlockDomain> events;

  /// Fires when the auth session changes (sign-in, sign-out, user switch,
  /// token refresh).
  final Stream<void> authSessionChanges;

  /// Current signed-in user id, or null when signed out.
  final String? Function() authUserId;

  final Widget child;

  /// How long each toast stays visible before the next queued unlock shows.
  final Duration toastDuration;

  @override
  State<AchievementUnlockHost> createState() => _AchievementUnlockHostState();
}

class _AchievementUnlockHostState extends State<AchievementUnlockHost> {
  StreamSubscription<AchievementUnlockDomain>? _eventsSub;
  StreamSubscription<void>? _authSub;
  final List<AchievementUnlockDomain> _pending = [];
  var _showing = false;
  OverlayEntry? _toastEntry;
  Timer? _toastTimer;
  Completer<void>? _toastWait;
  String? _boundUserId;

  @override
  void initState() {
    super.initState();
    _boundUserId = widget.authUserId();
    _eventsSub = widget.events.listen(_enqueue, onError: (_) {});
    _authSub = widget.authSessionChanges.listen((_) => _onAuthChanged());
  }

  @override
  void didUpdateWidget(AchievementUnlockHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _eventsSub?.cancel();
      _eventsSub = widget.events.listen(_enqueue, onError: (_) {});
    }
    if (oldWidget.authSessionChanges != widget.authSessionChanges) {
      _authSub?.cancel();
      _authSub = widget.authSessionChanges.listen((_) => _onAuthChanged());
    }
  }

  @override
  void dispose() {
    _eventsSub?.cancel();
    _authSub?.cancel();
    _pending.clear();
    _cancelToastWait();
    _removeToast();
    super.dispose();
  }

  void _onAuthChanged() {
    final nextUserId = widget.authUserId();
    // Token refresh keeps the same user id — leave the queue alone.
    if (nextUserId == _boundUserId) return;
    _boundUserId = nextUserId;
    _clearUnlockUi();
  }

  void _clearUnlockUi() {
    _pending.clear();
    _cancelToastWait();
    _removeToast();
    hideLumeSnackBar();
  }

  void _enqueue(AchievementUnlockDomain event) {
    if (widget.authUserId() == null) return;
    if (event.name.trim().isEmpty) return;
    _pending.add(event);
    unawaited(_drain());
  }

  Future<void> _drain() async {
    if (_showing) return;
    _showing = true;
    while (_pending.isNotEmpty && mounted && widget.authUserId() != null) {
      final event = _pending.removeAt(0);
      if (!_present(event)) {
        _pending.insert(0, event);
        _showing = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(_drain());
        });
        return;
      }
      await _waitToastDuration();
      if (!mounted || widget.authUserId() == null) break;
      _removeToast();
    }
    _showing = false;
    if (widget.authUserId() == null) {
      _clearUnlockUi();
    }
  }

  Future<void> _waitToastDuration() async {
    _cancelToastWait();
    final wait = Completer<void>();
    _toastWait = wait;
    _toastTimer = Timer(widget.toastDuration, () {
      if (!wait.isCompleted) wait.complete();
    });
    await wait.future;
  }

  void _cancelToastWait() {
    _toastTimer?.cancel();
    _toastTimer = null;
    final wait = _toastWait;
    _toastWait = null;
    if (wait != null && !wait.isCompleted) {
      wait.complete();
    }
  }

  bool _present(AchievementUnlockDomain event) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return false;

    _removeToast();
    final text = achievementUnlockedSnackBarText(event.name.trim());
    final entry = OverlayEntry(
      builder: (ctx) {
        return Positioned(
          left: AppSpacings.l,
          right: AppSpacings.l,
          top: 0,
          child: SafeArea(
            bottom: false,
            maintainBottomViewPadding: true,
            minimum: const EdgeInsets.only(top: AppSpacings.l),
            child: Semantics(
              liveRegion: true,
              child: LumeSnackBar(
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.Accent.accent,
                text: text,
                trait: LumeSnackBarTrait.brand,
                hasCloseButton: false,
              ),
            ),
          ),
        );
      },
    );
    _toastEntry = entry;
    overlay.insert(entry);
    return true;
  }

  void _removeToast() {
    _toastEntry?.remove();
    _toastEntry = null;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
