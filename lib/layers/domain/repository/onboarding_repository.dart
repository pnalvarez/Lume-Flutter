abstract interface class IOnboardingRepository {
  Future<bool> hasSeenOnboarding();

  Future<void> markOnboardingSeen();
}
