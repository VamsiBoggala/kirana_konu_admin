import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Model for hub registration request
class HubRequest extends Equatable {
  final String id;
  final String userId;
  final String shopName;
  final String ownerName;
  final String phoneNumber;
  final String address;
  final String? gstNumber;
  final String? panNumber;
  final String? shopLicense;
  final String? fssaiNumber;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, String?> documents; // Map of document type to URL

  const HubRequest({
    required this.id,
    required this.userId,
    required this.shopName,
    required this.ownerName,
    required this.phoneNumber,
    required this.address,
    this.gstNumber,
    this.panNumber,
    this.shopLicense,
    this.fssaiNumber,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.documents = const {},
  });

  /// Create from Firestore document
  factory HubRequest.fromFirestore(String id, Map<String, dynamic> data) {
    // Extract address from location map
    final location = data['location'] as Map<String, dynamic>?;
    final address = location?['address'] ?? '';

    // Extract document numbers and URLs from documents map
    final documentsData = data['documents'] as Map<String, dynamic>?;
    final gstData = documentsData?['gstin'] as Map<String, dynamic>?;
    final panData = documentsData?['pan'] as Map<String, dynamic>?;
    final shopLicenseData = documentsData?['shop_license'] as Map<String, dynamic>?;
    final fssaiData = documentsData?['fssai'] as Map<String, dynamic>?;

    // Extract bank details
    final bankDetails = data['bank_details'] as Map<String, dynamic>?;

    // Build documents map with URLs
    final Map<String, String?> documents = {};
    if (gstData?['document_url'] != null) {
      documents['GST Certificate'] = gstData!['document_url'];
    }
    if (panData?['document_url'] != null) {
      documents['PAN Card'] = panData!['document_url'];
    }
    if (shopLicenseData?['document_url'] != null) {
      documents['Shop License'] = shopLicenseData!['document_url'];
    }
    if (fssaiData?['document_url'] != null) {
      documents['FSSAI Certificate'] = fssaiData!['document_url'];
    }
    if (bankDetails?['cancelled_cheque_url'] != null) {
      documents['Cancelled Cheque'] = bankDetails!['cancelled_cheque_url'];
    }

    return HubRequest(
      id: id,
      userId: data['userId'] ?? data['owner_uid'] ?? '',
      shopName: data['shop_name'] ?? '',
      ownerName: data['owner_name'] ?? '',
      phoneNumber: data['mobile_number'] ?? '',
      address: address,
      gstNumber: gstData?['number'],
      panNumber: panData?['number'],
      shopLicense: shopLicenseData?['number'],
      fssaiNumber: fssaiData?['number'],
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      documents: documents,
    );
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shop_name': shopName,
      'owner_name': ownerName,
      'mobile_number': phoneNumber,
      'location': {'address': address},
      'documents': {
        'gstin': {'number': gstNumber},
        'pan': {'number': panNumber},
        'shop_license': {'number': shopLicense},
        'fssai': {'number': fssaiNumber},
      },
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Copy with method
  HubRequest copyWith({String? status, DateTime? updatedAt}) {
    return HubRequest(
      id: id,
      userId: userId,
      shopName: shopName,
      ownerName: ownerName,
      phoneNumber: phoneNumber,
      address: address,
      gstNumber: gstNumber,
      panNumber: panNumber,
      shopLicense: shopLicense,
      fssaiNumber: fssaiNumber,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documents: documents,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    shopName,
    ownerName,
    phoneNumber,
    address,
    gstNumber,
    panNumber,
    shopLicense,
    fssaiNumber,
    status,
    createdAt,
    updatedAt,
    documents,
  ];
}
