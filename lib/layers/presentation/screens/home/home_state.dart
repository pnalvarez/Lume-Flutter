import 'package:flutter/foundation.dart';

@immutable
final class HomeState {
  const HomeState({
    this.isSigningOut = false,
    this.goToLogin = false,
    this.errorMessage,
  });

  final bool isSigningOut;
  final bool goToLogin;
  final String? errorMessage;

  HomeState copyWith({
    bool? isSigningOut,
    bool? goToLogin,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      isSigningOut: isSigningOut ?? this.isSigningOut,
      goToLogin: goToLogin ?? this.goToLogin,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HomeState &&
      other.isSigningOut == isSigningOut &&
      other.goToLogin == goToLogin &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(isSigningOut, goToLogin, errorMessage);
}
