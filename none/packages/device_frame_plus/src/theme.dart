import 'package:flutter/material.dart';

/// The theme gives a [style] to all its descentant device frames.
///
/// The only customizable visuals are the keyboard style.
class DeviceFrameTheme extends InheritedWidget {
  /// Give a [style] to all descentant in [child] device frames.
  const DeviceFrameTheme({
    super.key,
    required this.style,
    required super.child,
  });

  /// The style of the device frame.
  final DeviceFrameStyle style;

  /// The data from the closest instance of this class that encloses the given
  /// [context].
  static DeviceFrameStyle of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DeviceFrameTheme>();

    return widget?.style ?? DeviceFrameStyle.dark();
  }

  @override
  bool updateShouldNotify(DeviceFrameTheme oldWidget) {
    return oldWidget.style != style;
  }
}

/// The device frame style only allows to update the [keyboardStyle] for now.
///
/// See also:
///
/// * [DeviceKeyboardStyle] to customize the virtual on screen keyboard.
class DeviceFrameStyle {
  final DeviceKeyboardStyle keyboardStyle;

  const DeviceFrameStyle({
    required this.keyboardStyle,
  });

  factory DeviceFrameStyle.dark({DeviceKeyboardStyle? keyboardStyle}) => DeviceFrameStyle(
        keyboardStyle: keyboardStyle ?? DeviceKeyboardStyle.dark(),
      );

  DeviceFrameStyle copyWith({
    DeviceKeyboardStyle? keyboardStyle,
  }) {
    return DeviceFrameStyle(
      keyboardStyle: keyboardStyle ?? this.keyboardStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceFrameStyle && runtimeType == other.runtimeType && keyboardStyle == other.keyboardStyle;

  @override
  int get hashCode => keyboardStyle.hashCode;

  @override
  String toString() => 'DeviceFrameStyle(keyboardStyle: $keyboardStyle)';
}

/// The keyboard style allows to customize the virtual onscreen keyboard visuals.
class DeviceKeyboardStyle {
  final Color backgroundColor;
  final Color button1BackgroundColor;
  final Color button1ForegroundColor;
  final Color button2BackgroundColor;
  final Color button2ForegroundColor;

  const DeviceKeyboardStyle({
    required this.backgroundColor,
    required this.button1BackgroundColor,
    required this.button1ForegroundColor,
    required this.button2BackgroundColor,
    required this.button2ForegroundColor,
  });

  factory DeviceKeyboardStyle.dark() {
    return const DeviceKeyboardStyle(
      backgroundColor: Color(0xDD2B2B2D),
      button1BackgroundColor: Color(0xFF6D6D6E),
      button1ForegroundColor: Colors.white,
      button2BackgroundColor: Color(0xFF4A4A4B),
      button2ForegroundColor: Colors.white,
    );
  }

  DeviceKeyboardStyle copyWith({
    Color? backgroundColor,
    Color? button1BackgroundColor,
    Color? button1ForegroundColor,
    Color? button2BackgroundColor,
    Color? button2ForegroundColor,
  }) {
    return DeviceKeyboardStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      button1BackgroundColor: button1BackgroundColor ?? this.button1BackgroundColor,
      button1ForegroundColor: button1ForegroundColor ?? this.button1ForegroundColor,
      button2BackgroundColor: button2BackgroundColor ?? this.button2BackgroundColor,
      button2ForegroundColor: button2ForegroundColor ?? this.button2ForegroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceKeyboardStyle &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          button1BackgroundColor == other.button1BackgroundColor &&
          button1ForegroundColor == other.button1ForegroundColor &&
          button2BackgroundColor == other.button2BackgroundColor &&
          button2ForegroundColor == other.button2ForegroundColor;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      button1BackgroundColor.hashCode ^
      button1ForegroundColor.hashCode ^
      button2BackgroundColor.hashCode ^
      button2ForegroundColor.hashCode;

  @override
  String toString() =>
      'DeviceKeyboardStyle(backgroundColor: $backgroundColor, button1BackgroundColor: $button1BackgroundColor, button1ForegroundColor: $button1ForegroundColor, button2BackgroundColor: $button2BackgroundColor, button2ForegroundColor: $button2ForegroundColor)';
}
