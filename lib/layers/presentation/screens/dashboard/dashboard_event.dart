import 'package:flutter/foundation.dart';

@immutable
sealed class DashboardEvent {
  const DashboardEvent();
}

final class DashboardSignOutPressed extends DashboardEvent {
  const DashboardSignOutPressed();
}

final class DashboardNavigationHandled extends DashboardEvent {
  const DashboardNavigationHandled();
}
