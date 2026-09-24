import 'package:flutter/foundation.dart';

@immutable
final class DashboardState {
  const DashboardState({
    this.isSigningOut = false,
    this.goToLogin = false,
    this.errorMessage,
    this.showAchievements = false,
  });

  final bool isSigningOut;
  final bool goToLogin;
  final String? errorMessage;
  final bool showAchievements;

  DashboardState copyWith({
    bool? isSigningOut,
    bool? goToLogin,
    String? errorMessage,
    bool? showAchievements,
    bool clearError = false,
  }) {
    return DashboardState(
      isSigningOut: isSigningOut ?? this.isSigningOut,
      goToLogin: goToLogin ?? this.goToLogin,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      showAchievements: showAchievements ?? this.showAchievements,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DashboardState &&
      other.isSigningOut == isSigningOut &&
      other.goToLogin == goToLogin &&
      other.errorMessage == errorMessage &&
      other.showAchievements == showAchievements;

  @override
  int get hashCode =>
      Object.hash(isSigningOut, goToLogin, errorMessage, showAchievements);
}
