/// Registers this device's FCM token and timezone for push notifications.
abstract interface class IPushDeviceRepository {
  /// Shows the OS permission prompt when needed; `true` when granted.
  Future<bool> requestPermission();

  /// Upserts token, platform and timezone for the signed-in user.
  ///
  /// Never prompts. Returns `false` when nothing was sent (permission not
  /// granted, no token/timezone, no session) and `true` when the server row
  /// is up to date.
  Future<bool> registerCurrentDevice();

  /// Removes this device's token server-side and invalidates it locally.
  /// Must run while the user is still signed in.
  Future<void> unregisterCurrentDevice();

  /// Emits when the FCM token rotates.
  Stream<void> watchTokenRefresh();

  /// Emits when the user taps a push notification while the app is open in
  /// the background.
  Stream<void> watchNotificationTaps();
}
