import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';

/// Dashboard shell chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class DashboardBody extends StatelessWidget {
  const DashboardBody({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.child,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final Widget child;

  static const navItems = [
    BottomNavItem(icon: Icons.home_rounded, label: dashboardTabTrail),
    BottomNavItem(icon: Icons.sports_esports_rounded, label: dashboardTabGames),
    BottomNavItem(icon: Icons.bar_chart_rounded, label: dashboardTabProgress),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        items: navItems,
        selectedIndex: selectedIndex,
        onSelected: onTabSelected,
      ),
    );
  }
}
