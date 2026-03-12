import 'package:flutter/material.dart';
import '../../dashboard/widgets/dashboard_layout.dart';
import '../models/hub_request_model.dart';
import '../services/hub_requests_service.dart';

/// Hub request detail screen showing all documents and information
class HubRequestDetailScreen extends StatelessWidget {
  final HubRequest request;

  const HubRequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      currentRoute: '/hub-request-detail',
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildInfoSection(context),
              const SizedBox(height: 24),
              _buildDocumentsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (MediaQuery.of(context).size.width < 768)
          IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(request.shopName, style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Hub Request Details',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
        if (request.status == 'pending') ...[
          // Reject button
          OutlinedButton.icon(
            onPressed: () => _showRejectConfirmation(context),
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
          const SizedBox(width: 12),
          // Approve button
          FilledButton.icon(
            onPressed: () => _showApproveConfirmation(context),
            icon: const Icon(Icons.check),
            label: const Text('Approve'),
            style: FilledButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          ),
          const SizedBox(width: 12),
        ],
        _buildStatusChip(context),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;

    switch (request.status) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Chip(
      label: Text(request.status.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: statusColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: statusColor),
      side: BorderSide.none,
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Shop Name', request.shopName),
            _buildInfoRow('Owner Name', request.ownerName),
            _buildInfoRow('Phone', request.phoneNumber),
            _buildInfoRow('Address', request.address),
            if (request.gstNumber != null) _buildInfoRow('GST Number', request.gstNumber!),
            if (request.panNumber != null) _buildInfoRow('PAN Number', request.panNumber!),
            if (request.shopLicense != null) _buildInfoRow('Shop License', request.shopLicense!),
            if (request.fssaiNumber != null) _buildInfoRow('FSSAI Number', request.fssaiNumber!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(BuildContext context) {
    final theme = Theme.of(context);

    if (request.documents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.image_not_supported, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text('No documents uploaded', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Documents & Images', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid columns based on screen width
                int crossAxisCount = constraints.maxWidth > 1200
                    ? 4
                    : constraints.maxWidth > 800
                    ? 3
                    : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: request.documents.length,
                  itemBuilder: (context, index) {
                    final entry = request.documents.entries.elementAt(index);
                    return _buildDocumentCard(context, entry.key, entry.value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, String label, String? url) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (url != null && url.isNotEmpty) {
            _showFullScreenImage(context, label, url);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: url != null && url.isNotEmpty
                  ? Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 48, color: theme.colorScheme.error),
                              const SizedBox(height: 8),
                              Text('Failed to load', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.image, size: 48, color: theme.colorScheme.onSurfaceVariant),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (url != null && url.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.zoom_in, size: 14, color: theme.colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Click to view',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String label, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Full screen image with zoom
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(48),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text('Failed to load image', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Header with title and close button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
            // Zoom hint at bottom
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pinch, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Pinch to zoom • Drag to pan', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog for approving request
  Future<void> _showApproveConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to approve this hub request for ${request.shopName}?'),
            const SizedBox(height: 16),
            const Text(
              'This action will grant hub privileges to this account.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _approveRequest(context);
    }
  }

  /// Show confirmation dialog for rejecting request
  Future<void> _showRejectConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to reject this hub request for ${request.shopName}?'),
            const SizedBox(height: 16),
            const Text(
              'This action will deny hub privileges to this account.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _rejectRequest(context);
    }
  }

  /// Approve the request via Firebase
  Future<void> _approveRequest(BuildContext context) async {
    final service = HubRequestsService();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Approving request...')],
            ),
          ),
        ),
      ),
    );

    try {
      await service.approveRequest(request.id);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request for ${request.shopName} has been approved successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Go back to list
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve request: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Reject the request via Firebase
  Future<void> _rejectRequest(BuildContext context) async {
    final service = HubRequestsService();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Rejecting request...')],
            ),
          ),
        ),
      ),
    );

    try {
      await service.rejectRequest(request.id);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request for ${request.shopName} has been rejected.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Go back to list
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject request: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
