import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/mark_onboarding_seen.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_bloc.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_event.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_slides.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_state.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(
        markOnboardingSeen: _DeferredMarkOnboardingSeen(),
      ),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.index != current.index ||
          previous.goToLogin != current.goToLogin,
      listener: (context, state) {
        if (state.goToLogin) {
          context.read<OnboardingBloc>().add(
            const OnboardingNavigationHandled(),
          );
          context.router.replace(const LoginRoute());
          return;
        }
        if (_controller.hasClients &&
            _controller.page?.round() != state.index) {
          _controller.animateToPage(
            state.index,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacings.xl,
                  AppSpacings.l,
                  AppSpacings.l,
                  AppSpacings.s,
                ),
                child: Row(
                  children: [
                    const LumeLogo(size: 40),
                    const SizedBox(width: AppSpacings.s),
                    Text(
                      authBrandTitle,
                      style: typ.subtitleM.copyWith(color: cs.onSurface),
                    ),
                    const Spacer(),
                    LumeButton(
                      label: onboardingSkip,
                      type: LumeButtonType.text,
                      size: LumeButtonSize.sm,
                      onPressed: () {
                        context.read<OnboardingBloc>().add(
                          const OnboardingSkipPressed(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingSlides.length,
                  onPageChanged: (index) {
                    context.read<OnboardingBloc>().add(
                      OnboardingPageChanged(index),
                    );
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingSlideView(slide: onboardingSlides[index]);
                  },
                ),
              ),
              const _OnboardingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaHeight = (constraints.maxHeight * 0.42).clamp(
          120.0,
          constraints.maxWidth * 0.75,
        );
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mediaHeight,
                    width: double.infinity,
                    child: slide.showGamification
                        ? const _GamificationIllustration()
                        : _SlideImage(slide: slide),
                  ),
                  const SizedBox(height: AppSpacings.xl2),
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: typ.headlineS.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacings.m),
                  Text(
                    slide.body,
                    textAlign: TextAlign.center,
                    style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SlideImage extends StatelessWidget {
  const _SlideImage({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl2),
      child: Image.asset(
        slide.imageAsset!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        semanticLabel: slide.alt,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: cs.primaryContainer,
            child: Icon(
              Icons.psychology_alt_rounded,
              size: AppSizes.iconXl,
              color: cs.secondary,
            ),
          );
        },
      ),
    );
  }
}

class _GamificationIllustration extends StatelessWidget {
  const _GamificationIllustration();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl2),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary.withValues(alpha: 0.3),
              cs.surfaceContainer,
              cs.secondary.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: AppSpacings.l,
              left: AppSpacings.xl2,
              child: SvgPicture.asset(
                AppIcons.sparkle,
                package: 'lume_design_system',
                width: AppSizes.iconS,
                height: AppSizes.iconS,
                colorFilter: ColorFilter.mode(cs.tertiary, BlendMode.srcIn),
              ),
            ),
            Positioned(
              top: AppSpacings.xl3,
              right: AppSpacings.xl3,
              child: SvgPicture.asset(
                AppIcons.star,
                package: 'lume_design_system',
                width: AppSizes.iconXs,
                height: AppSizes.iconXs,
                colorFilter: ColorFilter.mode(cs.tertiary, BlendMode.srcIn),
              ),
            ),
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: cs.tertiary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cs.tertiary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppIcons.trophy,
                    package: 'lume_design_system',
                    width: AppSizes.iconL,
                    height: AppSizes.iconL,
                    colorFilter: ColorFilter.mode(
                      cs.onTertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacings.xl2,
              right: AppSpacings.l,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: cs.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  border: Border.all(color: cs.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.m,
                    vertical: AppSpacings.s,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppIcons.star,
                        package: 'lume_design_system',
                        width: AppSizes.iconXs,
                        height: AppSizes.iconXs,
                        colorFilter: ColorFilter.mode(
                          cs.tertiary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: AppSpacings.xs),
                      Text(
                        onboardingLevelBadge,
                        style: typ.tagS.copyWith(color: cs.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacings.xl,
              right: AppSpacings.xl,
              bottom: AppSpacings.xl,
              child: LumeProgressBar(
                value: 0.82,
                label: onboardingXpLabel,
                showPercentage: false,
                fillColor: cs.tertiary,
                trackColor: cs.surface.withValues(alpha: 0.7),
                height: 12,
              ),
            ),
            Positioned(
              right: AppSpacings.xl,
              bottom: AppSpacings.xl + 20,
              child: Text(
                onboardingXpProgress,
                style: typ.tagS.copyWith(color: cs.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.xl2,
        AppSpacings.s,
        AppSpacings.xl2,
        AppSpacings.l,
      ),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < onboardingSlides.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacings.xs,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 8,
                        width: i == state.index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: i == state.index ? cs.secondary : cs.outline,
                          borderRadius: BorderRadius.circular(AppRadius.s),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacings.xl),
              LumeButton(
                label: state.isLast ? onboardingStart : onboardingNext,
                size: LumeButtonSize.lg,
                isExpanded: true,
                trailingIcon: state.isLast
                    ? null
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: cs.onPrimary,
                      ),
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingNextPressed(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

final class _DeferredMarkOnboardingSeen implements IMarkOnboardingSeen {
  @override
  Future<void> call() async {
    final useCase = await getIt.getAsync<IMarkOnboardingSeen>();
    return useCase();
  }
}
