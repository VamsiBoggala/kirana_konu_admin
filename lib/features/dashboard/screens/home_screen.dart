import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/dashboard_layout.dart';
import '../widgets/stat_card.dart';
import '../../hub_requests/bloc/hub_requests_bloc.dart';
import '../../hub_requests/bloc/hub_requests_event.dart';
import '../../hub_requests/bloc/hub_requests_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HubRequestsBloc()..add(const LoadHubRequests()),
      child: DashboardLayout(
        currentRoute: '/dashboard',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 24),

              // Statistics Cards
              _buildStatsGrid(context),
              const SizedBox(height: 32),

              // Recent Activity Section
              _buildRecentActivity(context),
              const SizedBox(height: 32),

              // Quick Actions Section
              _buildQuickActions(context),
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
              Text('Dashboard', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'Welcome back! Here\'s what\'s happening today.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (constraints.maxWidth < 1200) crossAxisCount = 2;
        if (constraints.maxWidth < 600) crossAxisCount = 1;

        return BlocBuilder<HubRequestsBloc, HubRequestsState>(
          builder: (context, state) {
            int totalHubs = 0;
            int pendingRequests = 0;

            if (state is HubRequestsLoaded) {
              totalHubs = state.requests.length;
              pendingRequests = state.requests.where((r) => r.status == 'pending').length;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  label: 'Total Hub Requests',
                  value: totalHubs.toString(),
                  icon: Icons.store,
                  color: Colors.blue,
                ),
                StatCard(
                  label: 'Pending Verifications',
                  value: pendingRequests.toString(),
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
                StatCard(
                  label: 'Active Users',
                  value: '1,248',
                  icon: Icons.people,
                  color: Colors.green,
                  trend: '+8%',
                  isPositiveTrend: true,
                ),
                StatCard(
                  label: 'Monthly Revenue',
                  value: '₹45.2K',
                  icon: Icons.currency_rupee,
                  color: Colors.purple,
                  trend: '+15%',
                  isPositiveTrend: true,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activities = [
                {
                  'icon': Icons.verified_user,
                  'title': 'New hub verified',
                  'subtitle': 'Srinivas Kirana Store',
                  'time': '5 min ago',
                  'color': Colors.green,
                },
                {
                  'icon': Icons.person_add,
                  'title': 'New user registered',
                  'subtitle': 'rajesh@example.com',
                  'time': '12 min ago',
                  'color': Colors.blue,
                },
                {
                  'icon': Icons.pending,
                  'title': 'Hub verification pending',
                  'subtitle': 'Lakshmi General Store',
                  'time': '1 hour ago',
                  'color': Colors.orange,
                },
                {
                  'icon': Icons.payment,
                  'title': 'Payment received',
                  'subtitle': '₹2,500 from subscription',
                  'time': '2 hours ago',
                  'color': Colors.purple,
                },
                {
                  'icon': Icons.block,
                  'title': 'User account suspended',
                  'subtitle': 'spam@example.com',
                  'time': '3 hours ago',
                  'color': Colors.red,
                },
              ];

              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: (activity['color'] as Color).withOpacity(0.1),
                  child: Icon(activity['icon'] as IconData, color: activity['color'] as Color, size: 20),
                ),
                title: Text(
                  activity['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(activity['subtitle'] as String),
                trailing: Text(
                  activity['time'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildActionButton(context, icon: Icons.add_business, label: 'Add New Hub', color: Colors.blue),
            _buildActionButton(context, icon: Icons.person_add, label: 'Invite User', color: Colors.green),
            _buildActionButton(context, icon: Icons.file_download, label: 'Export Report', color: Colors.purple),
            _buildActionButton(context, icon: Icons.notifications, label: 'Send Notification', color: Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
