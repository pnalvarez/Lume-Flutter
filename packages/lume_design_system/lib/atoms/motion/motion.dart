/// Animation tokens for [lume_design_system].
///
/// Lume uses many micro-animations (XP sparks, level-up, mastery badge flip).
/// Centralise durations and curves here so all transitions stay consistent.
library;

import 'package:flutter/material.dart';

abstract final class AppMotion {
  AppMotion._();

  // --- Durations -----------------------------------------------------------

  /// 100 ms — instant feedback (ripple, checkbox).
  static const Duration fast = Duration(milliseconds: 100);

  /// 200 ms — default short transition (color swap, icon swap).
  static const Duration normal = Duration(milliseconds: 200);

  /// 350 ms — standard page / card transition.
  static const Duration slow = Duration(milliseconds: 350);

  /// 600 ms — elaborate celebration animations (level-up, chest open).
  static const Duration xSlow = Duration(milliseconds: 600);

  /// 800 ms — full onboarding / reward sequence.
  static const Duration xxSlow = Duration(milliseconds: 800);

  // --- Standard curves -----------------------------------------------------

  /// Ease-in-out for most state changes.
  static const Curve standard = Curves.easeInOut;

  /// Ease-out for elements entering the screen.
  static const Curve decelerate = Curves.easeOut;

  /// Ease-in for elements leaving the screen.
  static const Curve accelerate = Curves.easeIn;

  /// Springy entrance — used for XP pop-in and badge appearances.
  static const Curve spring = Curves.elasticOut;

  /// Bouncy finish — used for progress bar fill.
  static const Curve bounceOut = Curves.bounceOut;

  // --- Spring physics params (for [SpringSimulation] / [SpringDescription]) --

  /// Damping ratio for a snappy, non-oscillating spring.
  static const double springDamping = 0.7;

  /// Stiffness for badge and icon pop-in.
  static const double springStiffness = 300.0;
}
