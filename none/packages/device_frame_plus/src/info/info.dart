import 'package:device_frame_plus/src/devices/generic/desktop_monitor/device.dart';
import 'package:device_frame_plus/src/devices/generic/laptop/device.dart';
import 'package:device_frame_plus/src/devices/generic/phone/device.dart';
import 'package:device_frame_plus/src/devices/generic/tablet/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'identifier.dart';

/// Info about a device and its frame.
class DeviceInfo {
  final DeviceIdentifier identifier;
  final String name;
  final EdgeInsets? rotatedSafeAreas;
  final EdgeInsets safeAreas;
  final Path screenPath;
  final double pixelRatio;
  final CustomPainter framePainter;
  final Size frameSize;
  final Size screenSize;

  const DeviceInfo({
    required this.identifier,
    required this.name,
    this.rotatedSafeAreas,
    required this.safeAreas,
    required this.screenPath,
    required this.pixelRatio,
    required this.framePainter,
    required this.frameSize,
    required this.screenSize,
  });

  // Factory constructors for generic devices
  factory DeviceInfo.genericTablet({
    required TargetPlatform platform,
    required String id,
    required String name,
    required Size screenSize,
    EdgeInsets safeAreas = EdgeInsets.zero,
    EdgeInsets rotatedSafeAreas = EdgeInsets.zero,
    double pixelRatio = 2.0,
    GenericTabletFramePainter framePainter = const GenericTabletFramePainter(),
  }) =>
      buildGenericTabletDevice(
        platform: platform,
        id: id,
        name: name,
        screenSize: screenSize,
        safeAreas: safeAreas,
        rotatedSafeAreas: rotatedSafeAreas,
        pixelRatio: pixelRatio,
        framePainter: framePainter,
      );

  factory DeviceInfo.genericPhone({
    required TargetPlatform platform,
    required String id,
    required String name,
    required Size screenSize,
    EdgeInsets safeAreas = EdgeInsets.zero,
    EdgeInsets rotatedSafeAreas = EdgeInsets.zero,
    double pixelRatio = 2.0,
    GenericPhoneFramePainter framePainter = const GenericPhoneFramePainter(),
  }) =>
      buildGenericPhoneDevice(
        platform: platform,
        id: id,
        name: name,
        screenSize: screenSize,
        safeAreas: safeAreas,
        rotatedSafeAreas: rotatedSafeAreas,
        pixelRatio: pixelRatio,
        framePainter: framePainter,
      );

  factory DeviceInfo.genericDesktopMonitor({
    required TargetPlatform platform,
    required String id,
    required String name,
    required Size screenSize,
    required Rect windowPosition,
    EdgeInsets safeAreas = EdgeInsets.zero,
    double pixelRatio = 2.0,
    GenericDesktopMonitorFramePainter? framePainter,
  }) =>
      buildGenericDesktopMonitorDevice(
        platform: platform,
        id: id,
        name: name,
        screenSize: screenSize,
        windowPosition: windowPosition,
        safeAreas: safeAreas,
        pixelRatio: pixelRatio,
        framePainter: framePainter,
      );

  factory DeviceInfo.genericLaptop({
    required TargetPlatform platform,
    required String id,
    required String name,
    required Size screenSize,
    required Rect windowPosition,
    EdgeInsets safeAreas = EdgeInsets.zero,
    double pixelRatio = 2.0,
    GenericLaptopFramePainter? framePainter,
  }) =>
      buildGenericLaptopDevice(
        platform: platform,
        id: id,
        name: name,
        screenSize: screenSize,
        windowPosition: windowPosition,
        safeAreas: safeAreas,
        pixelRatio: pixelRatio,
        framePainter: framePainter,
      );

  DeviceInfo copyWith({
    DeviceIdentifier? identifier,
    String? name,
    EdgeInsets? rotatedSafeAreas,
    EdgeInsets? safeAreas,
    Path? screenPath,
    double? pixelRatio,
    CustomPainter? framePainter,
    Size? frameSize,
    Size? screenSize,
  }) {
    return DeviceInfo(
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      rotatedSafeAreas: rotatedSafeAreas ?? this.rotatedSafeAreas,
      safeAreas: safeAreas ?? this.safeAreas,
      screenPath: screenPath ?? this.screenPath,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      framePainter: framePainter ?? this.framePainter,
      frameSize: frameSize ?? this.frameSize,
      screenSize: screenSize ?? this.screenSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceInfo &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          name == other.name &&
          rotatedSafeAreas == other.rotatedSafeAreas &&
          safeAreas == other.safeAreas &&
          screenPath == other.screenPath &&
          pixelRatio == other.pixelRatio &&
          framePainter == other.framePainter &&
          frameSize == other.frameSize &&
          screenSize == other.screenSize;

  @override
  int get hashCode =>
      identifier.hashCode ^
      name.hashCode ^
      rotatedSafeAreas.hashCode ^
      safeAreas.hashCode ^
      screenPath.hashCode ^
      pixelRatio.hashCode ^
      framePainter.hashCode ^
      frameSize.hashCode ^
      screenSize.hashCode;

  @override
  String toString() {
    return 'DeviceInfo(identifier: $identifier, name: $name, rotatedSafeAreas: $rotatedSafeAreas, safeAreas: $safeAreas, screenPath: $screenPath, pixelRatio: $pixelRatio, framePainter: $framePainter, frameSize: $frameSize, screenSize: $screenSize)';
  }
}

extension DeviceInfoExtension on DeviceInfo {
  /// Indicates whether the device can rotate.
  bool get canRotate => rotatedSafeAreas != null;

  /// Indicates whether the current device info should be in landscape.
  ///
  /// This is true only if the device can rotate.
  bool isLandscape(Orientation orientation) {
    return canRotate && orientation == Orientation.landscape;
  }
}
