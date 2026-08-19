import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';
import 'package:lume/layers/domain/usecases/clear_password_recovery.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/domain/usecases/update_password.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_bloc.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/define_password/define_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_scaffold.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

@RoutePage()
class DefinePasswordPage extends StatelessWidget {
  const DefinePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DefinePasswordBloc(
        restoreSession: getIt<IRestoreSession>(),
        updatePassword: getIt<IUpdatePassword>(),
        clearPasswordRecovery: ClearPasswordRecovery(getIt<IAuthRepository>()),
      )..add(const DefinePasswordStarted()),
      child: const _DefinePasswordView(),
    );
  }
}

class _DefinePasswordView extends StatefulWidget {
  const _DefinePasswordView();

  @override
  State<_DefinePasswordView> createState() => _DefinePasswordViewState();
}

class _DefinePasswordViewState extends State<_DefinePasswordView> {
  late final TextEditingController _password;
  late final TextEditingController _confirm;

  @override
  void initState() {
    super.initState();
    _password = TextEditingController();
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DefinePasswordBloc, DefinePasswordState>(
      listenWhen: (previous, current) =>
          previous.destination != current.destination ||
          previous.notice != current.notice,
      listener: (context, state) {
        if (state.notice != null) {
          showAuthSnackBar(context, state.notice!, isError: false);
        }
        final destination = state.destination;
        if (destination == null) return;
        context.read<DefinePasswordBloc>().add(
          const DefinePasswordNavigationHandled(),
        );
        switch (destination) {
          case DefinePasswordDestination.home:
            context.router.replace(const HomeRoute());
          case DefinePasswordDestination.recoverPassword:
            context.router.replace(const RecoverPasswordRoute());
        }
      },
      child: AuthScaffold(
        subtitle: 'Definir nova senha',
        child: BlocBuilder<DefinePasswordBloc, DefinePasswordState>(
          builder: (context, state) {
            return switch (state.status) {
              DefinePasswordStatus.checking => const _CheckingContent(),
              DefinePasswordStatus.invalid => const _InvalidContent(),
              DefinePasswordStatus.ready => _ReadyForm(
                  password: _password,
                  confirm: _confirm,
                  state: state,
                ),
            };
          },
        ),
      ),
    );
  }
}

class _CheckingContent extends StatelessWidget {
  const _CheckingContent();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const CircularLoader(),
        const SizedBox(height: AppSpacings.m),
        Text(
          'Validando seu link de recuperação...',
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _InvalidContent extends StatelessWidget {
  const _InvalidContent();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: AppSizes.avatarL,
            height: AppSizes.avatarL,
            decoration: BoxDecoration(
              color: cs.errorContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.error_outline_rounded,
              color: cs.error,
              size: AppSizes.iconM,
            ),
          ),
        ),
        const SizedBox(height: AppSpacings.m),
        Text(
          'Link inválido ou expirado',
          textAlign: TextAlign.center,
          style: typ.subtitleM.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacings.s),
        Text(
          'Este link de recuperação não é mais válido. Solicite um novo para redefinir sua senha.',
          textAlign: TextAlign.center,
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.xl2),
        LumeButton(
          label: 'Solicitar novo link',
          size: LumeButtonSize.lg,
          onPressed: () {
            context.read<DefinePasswordBloc>().add(
              const DefinePasswordRequestNewLink(),
            );
          },
        ),
      ],
    );
  }
}

class _ReadyForm extends StatelessWidget {
  const _ReadyForm({
    required this.password,
    required this.confirm,
    required this.state,
  });

  final TextEditingController password;
  final TextEditingController confirm;
  final DefinePasswordState state;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final message = state.errorMessage ??
        ((state.password.isNotEmpty || state.confirmation.isNotEmpty)
            ? state.validationError
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Escolha uma nova senha para sua conta.',
          style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacings.l),
        InputField(
          controller: password,
          placeholder: 'nova senha',
          obscureText: true,
          onChanged: (value) {
            context.read<DefinePasswordBloc>().add(
              DefinePasswordChanged(value),
            );
          },
        ),
        const SizedBox(height: AppSpacings.m),
        InputField(
          controller: confirm,
          placeholder: 'confirmar nova senha',
          obscureText: true,
          onChanged: (value) {
            context.read<DefinePasswordBloc>().add(
              DefinePasswordConfirmChanged(value),
            );
          },
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacings.s),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: AppSizes.iconXs,
                color: cs.error,
              ),
              const SizedBox(width: AppSpacings.s),
              Expanded(
                child: Text(
                  message,
                  style: typ.body4Light.copyWith(color: cs.error),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacings.m),
        LumeButton(
          label: state.isSubmitting ? 'Salvando...' : 'Redefinir senha',
          size: LumeButtonSize.lg,
          isLoading: state.isSubmitting,
          onPressed: state.canSubmit
              ? () {
                  context.read<DefinePasswordBloc>().add(
                    const DefinePasswordSubmitted(),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
