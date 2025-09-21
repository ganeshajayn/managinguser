abstract class NetworkRepository {
  Stream<bool> get networkStatusStream;
  Future<bool> isConnected();
  void startMonitoring();
  void stopMonitoring();
}

