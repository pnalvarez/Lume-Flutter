/// Signed-in user profile.
class ProfileDomain {
  const ProfileDomain({
    required this.id,
    this.email,
    this.fullName,
    this.trailStartedAt,
  });

  final String id;
  final String? email;
  final String? fullName;
  final DateTime? trailStartedAt;
}
