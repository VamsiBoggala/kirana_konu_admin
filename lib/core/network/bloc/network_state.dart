import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Network State
/// Represents the current network connectivity status
abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class NetworkInitial extends NetworkState {
  const NetworkInitial();
}

/// Connected to Network
class NetworkConnected extends NetworkState {
  final List<ConnectivityResult> connectivityTypes;
  final String connectionType;

  const NetworkConnected({required this.connectivityTypes, required this.connectionType});

  @override
  List<Object?> get props => [connectivityTypes, connectionType];
}

/// Disconnected from Network
class NetworkDisconnected extends NetworkState {
  const NetworkDisconnected();
}

/// Network Connection Type Changed
class NetworkConnectionTypeChanged extends NetworkState {
  final String previousType;
  final String currentType;
  final List<ConnectivityResult> connectivityTypes;

  const NetworkConnectionTypeChanged({
    required this.previousType,
    required this.currentType,
    required this.connectivityTypes,
  });

  @override
  List<Object?> get props => [previousType, currentType, connectivityTypes];
}
