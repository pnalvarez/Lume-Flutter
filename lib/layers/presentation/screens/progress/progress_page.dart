import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_event.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_state.dart';
import 'package:lume/layers/presentation/screens/dashboard/dashboard_tab_placeholder.dart';

@RoutePage()
class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return DashboardTabPlaceholder(
          title: dashboardTabProgress,
          isSigningOut: state.isSigningOut,
          onSignOut: () {
            context.read<DashboardBloc>().add(const DashboardSignOutPressed());
          },
        );
      },
    );
  }
}
