/// Supplies the current access token for authenticated HTTP calls.
///
/// Keep this independent of any auth SDK so [ApiClient] stays transport-only.
abstract interface class AuthTokenProvider {
  /// JWT or opaque access token, or `null` when the user is signed out.
  String? get accessToken;
}
