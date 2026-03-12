import 'package:flutter_bloc/flutter_bloc.dart';
import 'hub_requests_event.dart';
import 'hub_requests_state.dart';
import '../models/hub_request_model.dart';
import '../services/hub_requests_service.dart';

/// BLoC for managing hub requests
class HubRequestsBloc extends Bloc<HubRequestsEvent, HubRequestsState> {
  final HubRequestsService _service;

  HubRequestsBloc({HubRequestsService? service})
    : _service = service ?? HubRequestsService(),
      super(const HubRequestsInitial()) {
    on<LoadHubRequests>(_onLoadHubRequests);
    on<UpdateRequestStatus>(_onUpdateRequestStatus);
    on<ApproveRequest>(_onApproveRequest);
    on<RejectRequest>(_onRejectRequest);
  }

  /// Load hub requests using emit.forEach for proper stream handling
  Future<void> _onLoadHubRequests(LoadHubRequests event, Emitter<HubRequestsState> emit) async {
    emit(const HubRequestsLoading());

    try {
      await emit.forEach<List<HubRequest>>(
        _service.getHubRequestsStream(),
        onData: (requests) => HubRequestsLoaded(requests),
        onError: (error, stackTrace) => HubRequestsError('Failed to load requests: $error'),
      );
    } catch (e) {
      emit(HubRequestsError('Failed to load requests: $e'));
    }
  }

  /// Update request status
  Future<void> _onUpdateRequestStatus(UpdateRequestStatus event, Emitter<HubRequestsState> emit) async {
    emit(HubRequestsUpdating(event.requestId));

    try {
      await _service.updateRequestStatus(event.requestId, event.status);
      emit(HubRequestsStatusUpdated(requestId: event.requestId, status: event.status));
    } catch (e) {
      emit(HubRequestsError('Failed to update status: $e'));
    }
  }

  /// Approve request
  Future<void> _onApproveRequest(ApproveRequest event, Emitter<HubRequestsState> emit) async {
    add(UpdateRequestStatus(requestId: event.requestId, status: 'approved'));
  }

  /// Reject request
  Future<void> _onRejectRequest(RejectRequest event, Emitter<HubRequestsState> emit) async {
    add(UpdateRequestStatus(requestId: event.requestId, status: 'rejected'));
  }
}
