import 'package:flutter/foundation.dart';

@immutable
sealed class DashboardEvent {
  const DashboardEvent();
}

/// Dispatched when the dashboard shell first mounts.
///
/// Fires [AnalyticsEvents.achievementsTabImpression] if the Achievements tab
/// is visible, giving a clean exposure metric independent of RPC success.
final class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

final class DashboardSignOutPressed extends DashboardEvent {
  const DashboardSignOutPressed();
}

final class DashboardNavigationHandled extends DashboardEvent {
  const DashboardNavigationHandled();
}
