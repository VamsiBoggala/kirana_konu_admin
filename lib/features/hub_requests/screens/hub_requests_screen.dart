import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../dashboard/widgets/dashboard_layout.dart';
import '../../../core/routes/app_routes.dart';
import '../bloc/hub_requests_bloc.dart';
import '../bloc/hub_requests_event.dart';
import '../bloc/hub_requests_state.dart';
import '../models/hub_request_model.dart';

class HubRequestsScreen extends StatelessWidget {
  const HubRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      currentRoute: '/hub-requests',
      child: BlocProvider(
        create: (context) => HubRequestsBloc()..add(const LoadHubRequests()),
        child: const _HubRequestsContent(),
      ),
    );
  }
}

class _HubRequestsContent extends StatelessWidget {
  const _HubRequestsContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, theme),
            const SizedBox(height: 24),

            // Requests List
            BlocBuilder<HubRequestsBloc, HubRequestsState>(
              builder: (context, state) {
                if (state is HubRequestsLoading) {
                  return const Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator());
                }

                if (state is HubRequestsError) {
                  return Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<HubRequestsBloc>().add(const LoadHubRequests());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is HubRequestsLoaded) {
                  if (state.requests.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.inbox, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text('No hub requests found', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            'Hub registration requests will appear here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildRequestsList(context, state.requests);
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        // Mobile menu button
        if (MediaQuery.of(context).size.width < 768)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hub Requests', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Review and approve hub registration requests',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () {
            context.read<HubRequestsBloc>().add(const LoadHubRequests());
          },
        ),
      ],
    );
  }

  Widget _buildRequestsList(BuildContext context, List<HubRequest> requests) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: requests.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final request = requests[index];
          return _buildRequestItem(context, request);
        },
      ),
    );
  }

  Widget _buildRequestItem(BuildContext context, HubRequest request) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    Color statusColor;
    IconData statusIcon;
    switch (request.status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRoutes.dashboardHubRequestDetail, arguments: request);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Status Icon
                  CircleAvatar(
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // Shop Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.shopName,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.ownerName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Chip
                  Chip(
                    label: Text(
                      request.status.toUpperCase(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                    backgroundColor: statusColor.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Details Grid
              Row(
                children: [
                  Expanded(child: _buildInfoColumn(context, Icons.phone, 'Phone', request.phoneNumber)),
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      Icons.location_on,
                      'Location',
                      request.address.length > 30 ? '${request.address.substring(0, 30)}...' : request.address,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoColumn(context, Icons.receipt, 'GST Number', request.gstNumber ?? 'Not provided'),
                  ),
                  Expanded(
                    child: _buildInfoColumn(
                      context,
                      Icons.access_time,
                      'Submitted',
                      dateFormat.format(request.createdAt),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.dashboardHubRequestDetail, arguments: request);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
