import 'package:equatable/equatable.dart';
import '../models/hub_request_model.dart';

/// Hub requests states
abstract class HubRequestsState extends Equatable {
  const HubRequestsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HubRequestsInitial extends HubRequestsState {
  const HubRequestsInitial();
}

/// Loading state
class HubRequestsLoading extends HubRequestsState {
  const HubRequestsLoading();
}

/// Loaded state
class HubRequestsLoaded extends HubRequestsState {
  final List<HubRequest> requests;

  const HubRequestsLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

/// Error state
class HubRequestsError extends HubRequestsState {
  final String message;

  const HubRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Updating status state
class HubRequestsUpdating extends HubRequestsState {
  final String requestId;

  const HubRequestsUpdating(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

/// Status updated state
class HubRequestsStatusUpdated extends HubRequestsState {
  final String requestId;
  final String status;

  const HubRequestsStatusUpdated({required this.requestId, required this.status});

  @override
  List<Object?> get props => [requestId, status];
}
