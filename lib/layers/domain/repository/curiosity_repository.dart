import 'package:lume/layers/domain/models/curiosity/curiosity_domain.dart';

abstract interface class ICuriosityRepository {
  /// Today's curiosity for the client-local calendar [day], or `null` when the
  /// backend has no active curiosity to assign. Falls back to the cached copy
  /// for the same day when offline.
  Future<Curiosity?> getDailyCuriosity(DateTime day);

  Future<void> markCuriositySeen(String curiosityId);
}
