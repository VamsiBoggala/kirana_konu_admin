import 'package:equatable/equatable.dart';

/// Hub requests events
abstract class HubRequestsEvent extends Equatable {
  const HubRequestsEvent();

  @override
  List<Object?> get props => [];
}

/// Load hub requests
class LoadHubRequests extends HubRequestsEvent {
  const LoadHubRequests();
}

/// Update request status
class UpdateRequestStatus extends HubRequestsEvent {
  final String requestId;
  final String status;

  const UpdateRequestStatus({required this.requestId, required this.status});

  @override
  List<Object?> get props => [requestId, status];
}

/// Approve request
class ApproveRequest extends HubRequestsEvent {
  final String requestId;

  const ApproveRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

/// Reject request
class RejectRequest extends HubRequestsEvent {
  final String requestId;

  const RejectRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
