import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/network_repository.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkRepository _networkRepository;

  NetworkBloc(this._networkRepository) : super(NetworkInitial()) {
    on<StartNetworkMonitoring>(_onStartMonitoring);
    on<StopNetworkMonitoring>(_onStopMonitoring);
    on<NetworkStatusChanged>(_onNetworkStatusChanged);
  }

  void _onStartMonitoring(
    StartNetworkMonitoring event,
    Emitter<NetworkState> emit,
  ) {
    _networkRepository.startMonitoring();
    _networkRepository.networkStatusStream.listen((isConnected) {
      add(NetworkStatusChanged(isConnected));
    });
  }

  void _onStopMonitoring(
    StopNetworkMonitoring event,
    Emitter<NetworkState> emit,
  ) {
    _networkRepository.stopMonitoring();
  }

  void _onNetworkStatusChanged(
    NetworkStatusChanged event,
    Emitter<NetworkState> emit,
  ) {
    if (event.isConnected) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }
}

