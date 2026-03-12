import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_event.dart';
import 'network_state.dart';

/// Network Bloc
/// Monitors network connectivity and emits states based on connection changes
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  String? _previousConnectionType;

  NetworkBloc() : super(const NetworkInitial()) {
    on<StartNetworkMonitoring>(_onStartNetworkMonitoring);
    on<NetworkConnectivityChanged>(_onNetworkConnectivityChanged);
    on<StopNetworkMonitoring>(_onStopNetworkMonitoring);
  }

  /// Start monitoring network connectivity
  Future<void> _onStartNetworkMonitoring(StartNetworkMonitoring event, Emitter<NetworkState> emit) async {
    // Get initial connectivity status
    final initialResults = await _connectivity.checkConnectivity();
    final initialType = _getConnectionTypeString(initialResults);
    _previousConnectionType = initialType;

    if (_isConnected(initialResults)) {
      emit(NetworkConnected(connectivityTypes: initialResults, connectionType: initialType));
    } else {
      emit(const NetworkDisconnected());
    }

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      add(const NetworkConnectivityChanged());
    });
  }

  /// Handle connectivity changes
  Future<void> _onNetworkConnectivityChanged(NetworkConnectivityChanged event, Emitter<NetworkState> emit) async {
    final results = await _connectivity.checkConnectivity();
    final currentType = _getConnectionTypeString(results);

    if (_isConnected(results)) {
      // Check if connection type changed
      if (_previousConnectionType != null &&
          _previousConnectionType != currentType &&
          _previousConnectionType != 'none') {
        emit(
          NetworkConnectionTypeChanged(
            previousType: _previousConnectionType!,
            currentType: currentType,
            connectivityTypes: results,
          ),
        );
      }

      emit(NetworkConnected(connectivityTypes: results, connectionType: currentType));

      _previousConnectionType = currentType;
    } else {
      _previousConnectionType = 'none';
      emit(const NetworkDisconnected());
    }
  }

  /// Stop monitoring network connectivity
  Future<void> _onStopNetworkMonitoring(StopNetworkMonitoring event, Emitter<NetworkState> emit) async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Check if device is connected to any network
  bool _isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty && !results.every((result) => result == ConnectivityResult.none);
  }

  /// Get human-readable connection type string
  String _getConnectionTypeString(List<ConnectivityResult> results) {
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return 'none';
    }

    // Priority: WiFi > Ethernet > Mobile > VPN > Other
    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else if (results.contains(ConnectivityResult.other)) {
      return 'Other';
    }

    return 'Unknown';
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
