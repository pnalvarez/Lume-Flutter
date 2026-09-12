import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/personal_info/personal_info_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Personal-info chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class PersonalInfoBody extends StatefulWidget {
  const PersonalInfoBody({
    super.key,
    required this.state,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onAgeChanged,
    required this.onSubmit,
    this.onBack,
    this.onRetry,
  });

  final PersonalInfoState state;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onAgeChanged;
  final VoidCallback onSubmit;
  final VoidCallback? onBack;
  final VoidCallback? onRetry;

  @override
  State<PersonalInfoBody> createState() => _PersonalInfoBodyState();
}

class _PersonalInfoBodyState extends State<PersonalInfoBody> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _age;

  static const double _maxWidth = 400;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.state.firstName);
    _lastName = TextEditingController(text: widget.state.lastName);
    _age = TextEditingController(text: widget.state.age);
  }

  @override
  void didUpdateWidget(covariant PersonalInfoBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.firstName != _firstName.text) {
      _firstName.text = widget.state.firstName;
    }
    if (widget.state.lastName != _lastName.text) {
      _lastName.text = widget.state.lastName;
    }
    if (widget.state.age != _age.text) {
      _age.text = widget.state.age;
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = widget.state;
    final showHeader = state.isSettingsEntry && widget.onBack != null;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: showHeader
          ? PageHeader(
              title: personalInfoTitle,
              onBack: widget.onBack,
              titleLayout: PageHeaderTitleLayout.stacked,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: switch (state.status) {
              PersonalInfoStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              PersonalInfoStatus.error => Padding(
                padding: const EdgeInsets.all(AppSpacings.xl2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? personalInfoLoadError,
                      textAlign: TextAlign.center,
                      style: typ.body3Light.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    if (widget.onRetry != null) ...[
                      const SizedBox(height: AppSpacings.l),
                      LumeButton(
                        label: personalInfoRetry,
                        type: LumeButtonType.outlined,
                        onPressed: widget.onRetry,
                      ),
                    ],
                  ],
                ),
              ),
              PersonalInfoStatus.ready => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.xl2,
                  vertical: AppSpacings.l,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!state.isSettingsEntry) ...[
                      Text(
                        personalInfoTitle,
                        style: typ.headlineM.copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(height: AppSpacings.s),
                      Text(
                        personalInfoSubtitle,
                        style: typ.body3Light.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacings.l),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InputField(
                              controller: _firstName,
                              label: personalInfoFirstNameLabel,
                              placeholder: personalInfoFirstNamePlaceholder,
                              isEnabled: !state.isSubmitting,
                              onChanged: widget.onFirstNameChanged,
                            ),
                            const SizedBox(height: AppSpacings.m),
                            InputField(
                              controller: _lastName,
                              label: personalInfoLastNameLabel,
                              placeholder: personalInfoLastNamePlaceholder,
                              isEnabled: !state.isSubmitting,
                              onChanged: widget.onLastNameChanged,
                            ),
                            const SizedBox(height: AppSpacings.m),
                            InputField(
                              controller: _age,
                              label: personalInfoAgeLabel,
                              placeholder: personalInfoAgePlaceholder,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              isEnabled: !state.isSubmitting,
                              onChanged: widget.onAgeChanged,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacings.m),
                    LumeButton(
                      label: state.submitLabel,
                      size: LumeButtonSize.lg,
                      isLoading: state.isSubmitting,
                      isEnabled: state.canSubmit,
                      isExpanded: true,
                      onPressed: widget.onSubmit,
                    ),
                  ],
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}
