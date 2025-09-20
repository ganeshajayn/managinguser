abstract class NetworkEvent {}

class NetworkStatusChanged extends NetworkEvent {
  final bool isConnected;
  NetworkStatusChanged(this.isConnected);
}

class StartNetworkMonitoring extends NetworkEvent {}

class StopNetworkMonitoring extends NetworkEvent {}
