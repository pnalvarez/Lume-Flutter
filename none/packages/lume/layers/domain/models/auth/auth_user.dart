/// Signed-in identity in domain language.
class AuthUser {
  const AuthUser({
    required this.id,
    this.email,
    required this.isEmailConfirmed,
  });

  final String id;
  final String? email;
  final bool isEmailConfirmed;
}
