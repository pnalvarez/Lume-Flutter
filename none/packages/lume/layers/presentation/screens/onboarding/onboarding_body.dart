import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_slides.dart';
import 'package:lume/layers/presentation/shared/lume_logo.dart';
import 'package:lume_design_system/atoms/icons/app_icons.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';

/// Onboarding chrome. No Bloc, router, or GetIt — safe for Widgetbook.
class OnboardingBody extends StatelessWidget {
  const OnboardingBody({
    super.key,
    required this.pageController,
    required this.index,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
    required this.onPageChanged,
  });

  final PageController pageController;
  final int index;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
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
                    onPressed: onSkip,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingSlides.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, slideIndex) {
                  return _OnboardingSlideView(
                    slide: onboardingSlides[slideIndex],
                  );
                },
              ),
            ),
            _OnboardingFooter(index: index, isLast: isLast, onNext: onNext),
          ],
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
  const _OnboardingFooter({
    required this.index,
    required this.isLast,
    required this.onNext,
  });

  final int index;
  final bool isLast;
  final VoidCallback onNext;

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
      child: Column(
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
                    width: i == index ? 32 : 8,
                    decoration: BoxDecoration(
                      color: i == index ? cs.secondary : cs.outline,
                      borderRadius: BorderRadius.circular(AppRadius.s),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacings.xl),
          LumeButton(
            label: isLast ? onboardingStart : onboardingNext,
            size: LumeButtonSize.lg,
            isExpanded: true,
            trailingIcon: isLast
                ? null
                : Icon(Icons.chevron_right_rounded, color: cs.onPrimary),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
