import '../datasources/network_datasource.dart';
import '../../domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkDataSource _dataSource;

  NetworkRepositoryImpl(this._dataSource);

  @override
  Stream<bool> get networkStatusStream => _dataSource.networkStatusStream;

  @override
  Future<bool> isConnected() => _dataSource.isConnected();

  @override
  void startMonitoring() => _dataSource.startMonitoring();

  @override
  void stopMonitoring() => _dataSource.stopMonitoring();
}
