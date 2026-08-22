import 'package:flutter/foundation.dart';

@immutable
sealed class SplashEvent {
  const SplashEvent();
}

final class SplashStarted extends SplashEvent {
  const SplashStarted();
}
