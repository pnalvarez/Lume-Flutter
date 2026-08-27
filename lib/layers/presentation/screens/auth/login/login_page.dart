import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_body.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.notice != current.notice ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.notice != null) {
          showAuthSnackBar(context, state.notice!, isError: false);
        }
        if (state.errorMessage != null && state.destination == null) {
          showAuthSnackBar(context, state.errorMessage!);
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<LoginBloc>().add(const LoginNavigationHandled());
        switch (destination) {
          case LoginDestination.home:
            context.router.replaceAll([const DashboardRoute()]);
          case LoginDestination.selectCategory:
            context.router.replaceAll([SelectCategoryRoute()]);
          case LoginDestination.confirmEmail:
            context.router.push(ConfirmEmailRoute(email: state.email.trim()));
          case LoginDestination.recoverPassword:
            context.router.push(const RecoverPasswordRoute());
          case LoginDestination.onboarding:
            context.router.push(const OnboardingRoute());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return LoginBody(
            state: state,
            onEmailChanged: (value) {
              context.read<LoginBloc>().add(LoginEmailChanged(value));
            },
            onPasswordChanged: (value) {
              context.read<LoginBloc>().add(LoginPasswordChanged(value));
            },
            onSubmit: () {
              context.read<LoginBloc>().add(const LoginSubmitted());
            },
            onForgotPassword: () {
              context.read<LoginBloc>().add(const LoginForgotPasswordPressed());
            },
            onToggleMode: () {
              context.read<LoginBloc>().add(const LoginModeToggled());
            },
            onWhatIsLume: () {
              context.read<LoginBloc>().add(const LoginWhatIsLumePressed());
            },
          );
        },
      ),
    );
  }
}
