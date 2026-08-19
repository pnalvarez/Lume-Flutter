import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';

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
        subtitle: loginSubtitle,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  controller: _email,
                  placeholder: authEmailPlaceholder,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(LoginEmailChanged(value));
                  },
                ),
                const SizedBox(height: AppSpacings.m),
                InputField(
                  controller: _password,
                  placeholder: loginPasswordPlaceholder,
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
                      label: loginForgotPassword,
                      type: LumeButtonType.text,
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
                      ? loginCtaSignIn
                      : loginCtaSignUp,
                  size: LumeButtonSize.lg,
                  isLoading: state.isSubmitting,
                  isEnabled: state.canSubmit,
                  isExpanded: true,
                  onPressed: () {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  },
                ),
                const SizedBox(height: AppSpacings.l),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      state.mode == LoginMode.login
                          ? loginFooterNoAccountPrompt
                          : loginFooterHasAccountPrompt,
                      style: typ.body4Light.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    LumeButton(
                      label: state.mode == LoginMode.login
                          ? loginFooterNoAccountAction
                          : loginFooterHasAccountAction,
                      type: LumeButtonType.link,
                      size: LumeButtonSize.sm,
                      onPressed: () {
                        context.read<LoginBloc>().add(const LoginModeToggled());
                      },
                    ),
                  ],
                ),
                LumeButton(
                  label: loginWhatIsLume,
                  trait: LumeButtonTrait.secondary,
                  type: LumeButtonType.link,
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
