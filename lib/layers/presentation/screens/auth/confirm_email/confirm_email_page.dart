import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/resend_confirmation_email.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume/layers/presentation/shared/auth_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';

@RoutePage()
class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key, this.email = ''});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfirmEmailBloc(
        resendConfirmationEmail: getIt<IResendConfirmationEmail>(),
        email: email,
      ),
      child: _ConfirmEmailView(initialEmail: email),
    );
  }
}

class _ConfirmEmailView extends StatefulWidget {
  const _ConfirmEmailView({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ConfirmEmailView> createState() => _ConfirmEmailViewState();
}

class _ConfirmEmailViewState extends State<_ConfirmEmailView> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocListener<ConfirmEmailBloc, ConfirmEmailState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        showAuthSnackBar(context, notice, isError: state.isError);
        context.read<ConfirmEmailBloc>().add(const ConfirmEmailNoticeHandled());
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                backTooltip: authBack,
                onBack: () => context.router.maybePop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacings.xl2,
                    AppSpacings.l,
                    AppSpacings.xl2,
                    AppSpacings.l,
                  ),
                  child: BlocBuilder<ConfirmEmailBloc, ConfirmEmailState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: AppSizes.avatarL,
                              height: AppSizes.avatarL,
                              decoration: BoxDecoration(
                                color: cs.tertiaryContainer,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.mark_email_read_rounded,
                                color: cs.tertiary,
                                size: AppSizes.iconM,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacings.m),
                          Text(
                            confirmEmailTitle,
                            textAlign: TextAlign.center,
                            style: typ.subtitleM.copyWith(color: cs.onSurface),
                          ),
                          const SizedBox(height: AppSpacings.s),
                          Text.rich(
                            TextSpan(
                              text: confirmEmailBodyPrefix,
                              style: typ.body4Light.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              children: [
                                if (state.email.trim().isNotEmpty)
                                  TextSpan(
                                    text: ' ${state.email.trim()}',
                                    style: typ.body4Medium.copyWith(
                                      color: cs.onSurface,
                                    ),
                                  )
                                else
                                  const TextSpan(
                                    text: confirmEmailBodyUnspecifiedRecipient,
                                  ),
                                const TextSpan(text: confirmEmailBodySuffix),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacings.xl2),
                          InputField(
                            controller: _email,
                            placeholder: authEmailPlaceholder,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              context.read<ConfirmEmailBloc>().add(
                                ConfirmEmailChanged(value),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacings.m),
                          LumeButton(
                            label: state.isSubmitting
                                ? confirmEmailResending
                                : confirmEmailResend,
                            size: LumeButtonSize.lg,
                            isExpanded: true,
                            isLoading: state.isSubmitting,
                            isEnabled: state.canResend,
                            onPressed: () {
                              context.read<ConfirmEmailBloc>().add(
                                const ConfirmEmailResendPressed(),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
