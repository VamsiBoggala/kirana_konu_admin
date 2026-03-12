import 'package:equatable/equatable.dart';

/// Base class for all Network Events
abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start monitoring network connectivity
class StartNetworkMonitoring extends NetworkEvent {
  const StartNetworkMonitoring();
}

/// Event when connectivity changes
class NetworkConnectivityChanged extends NetworkEvent {
  const NetworkConnectivityChanged();
}

/// Event to stop monitoring network connectivity
class StopNetworkMonitoring extends NetworkEvent {
  const StopNetworkMonitoring();
}
