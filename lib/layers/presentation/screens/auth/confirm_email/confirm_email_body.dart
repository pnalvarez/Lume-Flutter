import 'package:flutter/material.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';

/// Confirm-email chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class ConfirmEmailBody extends StatefulWidget {
  const ConfirmEmailBody({
    super.key,
    required this.state,
    required this.onBack,
    required this.onEmailChanged,
    required this.onResend,
  });

  final ConfirmEmailState state;
  final VoidCallback onBack;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onResend;

  @override
  State<ConfirmEmailBody> createState() => _ConfirmEmailBodyState();
}

class _ConfirmEmailBodyState extends State<ConfirmEmailBody> {
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.state.email);
  }

  @override
  void didUpdateWidget(covariant ConfirmEmailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.email != _email.text) {
      _email.text = widget.state.email;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = widget.state;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(backTooltip: authBack, onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacings.xl2,
                  AppSpacings.l,
                  AppSpacings.xl2,
                  AppSpacings.l,
                ),
                child: Column(
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
                      onChanged: widget.onEmailChanged,
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
                      onPressed: widget.onResend,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
