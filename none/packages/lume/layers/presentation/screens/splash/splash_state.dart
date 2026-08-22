import 'package:flutter/foundation.dart';
import 'package:lume/app/navigation/auth_gate.dart';

@immutable
sealed class SplashState {
  const SplashState();
}

final class SplashLoading extends SplashState {
  const SplashLoading();

  @override
  bool operator ==(Object other) => other is SplashLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

final class SplashReady extends SplashState {
  const SplashReady(this.destination);

  final SplashDestination destination;

  @override
  bool operator ==(Object other) =>
      other is SplashReady && other.destination == destination;

  @override
  int get hashCode => destination.hashCode;
}
