import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/push_device_data_source.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

@LazySingleton(as: IPushDeviceRepository)
final class PushDeviceRepository implements IPushDeviceRepository {
  PushDeviceRepository(this._dataSource);

  final IPushDeviceDataSource _dataSource;

  @override
  Future<bool> requestPermission() => _dataSource.requestPermission();

  @override
  Future<bool> registerCurrentDevice() => _dataSource.register();

  @override
  Future<void> unregisterCurrentDevice() => _dataSource.unregister();

  @override
  Stream<void> watchTokenRefresh() => _dataSource.watchTokenRefresh();

  @override
  Stream<void> watchNotificationTaps() => _dataSource.watchNotificationTaps();
}
