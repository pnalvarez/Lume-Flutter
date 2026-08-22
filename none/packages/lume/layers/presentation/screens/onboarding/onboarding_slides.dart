import 'package:lume/common/strings/auth_strings.dart';

/// Copy and media for the two-slide welcome carousel (web `Onboarding.tsx`).
class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.body,
    required this.alt,
    this.imageAsset,
    this.showGamification = false,
  });

  final String title;
  final String body;
  final String alt;
  final String? imageAsset;
  final bool showGamification;
}

const onboardingSlides = [
  OnboardingSlide(
    title: onboardingSlide1Title,
    body: onboardingSlide1Body,
    imageAsset: 'assets/onboarding/slide-1.jpg',
    alt: onboardingSlide1Alt,
  ),
  OnboardingSlide(
    title: onboardingSlide2Title,
    body: onboardingSlide2Body,
    alt: onboardingSlide2Alt,
    showGamification: true,
  ),
];
