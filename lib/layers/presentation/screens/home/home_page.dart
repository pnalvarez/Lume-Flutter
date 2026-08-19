import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/home/home_bloc.dart';
import 'package:lume/layers/presentation/screens/home/home_event.dart';
import 'package:lume/layers/presentation/screens/home/home_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(signOut: getIt<ISignOut>()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.goToLogin != current.goToLogin ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showAuthSnackBar(context, state.errorMessage!);
        }
        if (state.goToLogin) {
          context.read<HomeBloc>().add(const HomeNavigationHandled());
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        appBar: const PageHeader(title: homeTitle),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.xl2),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      homeTitle,
                      style: typ.headlineS.copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacings.s),
                    Text(
                      homeAuthenticatedMessage,
                      style: typ.body3Light.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacings.xl2),
                    LumeButton(
                      label: homeSignOut,
                      type: LumeButtonType.outlined,
                      isExpanded: true,
                      isLoading: state.isSigningOut,
                      onPressed: state.isSigningOut
                          ? null
                          : () {
                              context.read<HomeBloc>().add(
                                const HomeSignOutPressed(),
                              );
                            },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
