import 'package:lume/layers/data/models/profile_data.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';

abstract final class ProfileMapper {
  const ProfileMapper._();

  static ProfileDomain toDomain(ProfileData data) {
    return ProfileDomain(
      id: data.id,
      email: data.email,
      fullName: data.fullName,
      age: data.age,
      createdAt: data.createdAt,
      trailStartedAt: data.trailStartedAt,
      playerLevel: data.playerLevel,
      totalXp: data.totalXp,
      xpToNextLevel: data.xpToNextLevel,
      xpInLevel: data.xpInLevel,
      xpForNextLevel: data.xpForNextLevel,
      currentStreak: data.currentStreak,
      bestStreak: data.bestStreak,
      streakShields: data.streakShields,
      xpToday: data.xpToday,
      xpWeek: data.xpWeek,
      daysInApp: _daysInApp(data),
      submodulesCompleted: data.submodulesCompleted,
    );
  }

  /// `get_profile` often omits/zeros `days_in_app`. Derive it from
  /// `created_at` (which already has its own auth-session fallback applied
  /// in `ProfileDataSource`) so "No app" isn't stuck on 0.
  static int _daysInApp(ProfileData data) {
    if (data.daysInApp != 0) return data.daysInApp;
    final createdAt = data.createdAt;
    if (createdAt == null) return 0;
    final computed = DateTime.now().difference(createdAt).inDays;
    return computed > 0 ? computed : 0;
  }
}
