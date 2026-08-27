import 'package:lume/layers/data/models/profile_data.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';

abstract final class ProfileMapper {
  const ProfileMapper._();

  static ProfileDomain toDomain(ProfileData data) {
    return ProfileDomain(
      id: data.id,
      email: data.email,
      fullName: data.fullName,
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
      daysInApp: data.daysInApp,
      submodulesCompleted: data.submodulesCompleted,
    );
  }
}
