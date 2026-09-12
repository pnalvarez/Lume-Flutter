import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';

abstract interface class IHasCompletedPersonalInfo {
  Future<bool> call({bool forceRefresh = false});
}

@Injectable(as: IHasCompletedPersonalInfo)
class HasCompletedPersonalInfo implements IHasCompletedPersonalInfo {
  HasCompletedPersonalInfo(this._getProfile);

  final IGetProfile _getProfile;

  @override
  Future<bool> call({bool forceRefresh = false}) async {
    final profile = await _getProfile(forceRefresh: forceRefresh);
    final fullName = profile.fullName?.trim() ?? '';
    return fullName.isNotEmpty && profile.age != null;
  }
}
