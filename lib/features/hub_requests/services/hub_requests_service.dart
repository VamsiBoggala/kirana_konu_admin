import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hub_request_model.dart';

/// Service for managing hub requests in Firestore
class HubRequestsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'hub_requests';

  /// Get stream of all hub requests
  Stream<List<HubRequest>> getHubRequestsStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HubRequest.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  /// Get single hub request by ID
  Future<HubRequest?> getHubRequestById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return HubRequest.fromFirestore(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update hub request status
  Future<void> updateRequestStatus(String id, String status) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': status,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Approve hub request
  Future<void> approveRequest(String id) async {
    await updateRequestStatus(id, 'approved');
  }

  /// Reject hub request
  Future<void> rejectRequest(String id) async {
    await updateRequestStatus(id, 'rejected');
  }
}
