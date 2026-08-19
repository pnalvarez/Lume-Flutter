import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/login/login_bloc.dart';
import 'package:lume/layers/presentation/screens/login/login_event.dart';
import 'package:lume/layers/presentation/screens/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        signInWithEmail: getIt<ISignInWithEmail>(),
        signUpWithEmail: getIt<ISignUpWithEmail>(),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

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
            context.router.replace(const HomeRoute());
          case LoginDestination.confirmEmail:
            context.router.push(ConfirmEmailRoute(email: state.email.trim()));
          case LoginDestination.recoverPassword:
            context.router.push(const RecoverPasswordRoute());
          case LoginDestination.onboarding:
            context.router.push(const OnboardingRoute());
        }
      },
      child: AuthScaffold(
        subtitle: 'Microlearning de História Mundial',
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  controller: _email,
                  placeholder: 'email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(LoginEmailChanged(value));
                  },
                ),
                const SizedBox(height: AppSpacings.m),
                InputField(
                  controller: _password,
                  placeholder: 'senha',
                  obscureText: true,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(LoginPasswordChanged(value));
                  },
                ),
                if (state.mode == LoginMode.login) ...[
                  const SizedBox(height: AppSpacings.s),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LumeButton(
                      label: 'Esqueci minha senha',
                      variant: LumeButtonVariant.link,
                      size: LumeButtonSize.sm,
                      onPressed: () {
                        context.read<LoginBloc>().add(
                          const LoginForgotPasswordPressed(),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacings.m),
                LumeButton(
                  label: state.mode == LoginMode.login
                      ? 'Entrar'
                      : 'Criar conta',
                  size: LumeButtonSize.lg,
                  isLoading: state.isSubmitting,
                  onPressed: state.canSubmit
                      ? () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                ),
                const SizedBox(height: AppSpacings.l),
                LumeButton(
                  label: state.mode == LoginMode.login
                      ? 'Não tem conta? Criar uma'
                      : 'Já tem conta? Entrar',
                  variant: LumeButtonVariant.link,
                  onPressed: () {
                    context.read<LoginBloc>().add(const LoginModeToggled());
                  },
                ),
                LumeButton(
                  label: 'O que é o Lume?',
                  variant: LumeButtonVariant.link,
                  size: LumeButtonSize.sm,
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      const LoginWhatIsLumePressed(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
