import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkDataSource {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<bool> _networkStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get networkStatusStream => _networkStatusController.stream;

  Future<bool> isConnected() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  void startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final isConnected = results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
      _networkStatusController.add(isConnected);
      print(
        'Network status changed: ${isConnected ? "Connected" : "Disconnected"}',
      );
    });
  }

  void stopMonitoring() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
