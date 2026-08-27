import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/common/strings/profile_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/profile/profile_bloc.dart';
import 'package:lume/layers/presentation/screens/profile/profile_body.dart';
import 'package:lume/layers/presentation/screens/profile/profile_event.dart';
import 'package:lume/layers/presentation/screens/profile/profile_state.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_page.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Always force-refresh so XP/streak aren't served from a stale Home cache.
      create: (_) =>
          getIt<ProfileBloc>()..add(const ProfileStarted(forceRefresh: true)),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with AutoRouteAwareStateMixin<_ProfileView> {
  void _reload() {
    context.read<ProfileBloc>().add(const ProfileStarted(forceRefresh: true));
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    _reload();
  }

  @override
  void didPopNext() {
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.status != ProfileStatus.error,
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null) showAuthSnackBar(context, message);
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.destination != current.destination,
          listener: (context, state) {
            final destination = state.destination;
            if (destination == null) return;
            context.read<ProfileBloc>().add(const ProfileNavigationHandled());
            switch (destination) {
              case ProfileDestination.login:
                context.router.replaceAll([const LoginRoute()]);
              case ProfileDestination.settings:
                context.router.push(
                  SelectCategoryRoute(entry: SelectCategoryEntry.profile),
                );
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return ProfileBody(
            state: state,
            onRetry: _reload,
            onSettingsPressed: () {
              context.read<ProfileBloc>().add(const ProfileSettingsPressed());
            },
            onSignOutPressed: () async {
              final confirmed = await _confirmSignOut(context);
              if (!context.mounted || !confirmed) return;
              context.read<ProfileBloc>().add(const ProfileSignOutPressed());
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showLumeDialog<bool>(
      context: context,
      tone: LumeDialogTone.neutral,
      barrierDismissible: true,
      title: profileSignOutTitle,
      content: Text(
        profileSignOutBody,
        style: typ.body4Light.copyWith(color: cs.onSurface),
      ),
      actions: [
        Builder(
          builder: (dialogContext) => LumeButton(
            label: profileSignOutConfirm,
            type: LumeButtonType.elevated,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ),
        Builder(
          builder: (dialogContext) => LumeButton(
            label: profileSignOutCancel,
            type: LumeButtonType.outlined,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
        ),
      ],
    );
    return confirmed ?? false;
  }
}
