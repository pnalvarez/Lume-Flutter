/// Supplies the current access token for authenticated HTTP calls.
///
/// Keep this independent of any auth SDK so [IApiClient] stays transport-only.
abstract interface class IAuthTokenProvider {
  /// JWT or opaque access token, or `null` when the user is signed out.
  String? get accessToken;
}

/// Legacy name for [IAuthTokenProvider].
typedef AuthTokenProvider = IAuthTokenProvider;
