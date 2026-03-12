import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:kirana_admin_web/core/theme/theme_provider.dart';
import 'package:kirana_admin_web/core/constants/app_assets.dart';
import 'package:kirana_admin_web/core/routes/app_routes.dart';
import 'package:kirana_admin_web/core/utils/navigation_helper.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';
import '../../hub_requests/bloc/hub_requests_bloc.dart';
import '../../hub_requests/bloc/hub_requests_event.dart';
import '../../hub_requests/bloc/hub_requests_state.dart';

/// Modern sidebar navigation for admin dashboard
class AdminSidebar extends StatelessWidget {
  final String currentRoute;

  const AdminSidebar({super.key, this.currentRoute = '/dashboard'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => HubRequestsBloc()..add(const LoadHubRequests()),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          border: Border(right: BorderSide(color: theme.dividerColor, width: 1)),
        ),
        child: Column(
          children: [
            // Logo Section
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Image.asset(AppAssets.appLogo, width: 40, height: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kirana Konu', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text(
                          'Admin Panel',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Navigation Menu
            Expanded(
              child: BlocBuilder<HubRequestsBloc, HubRequestsState>(
                builder: (context, state) {
                  String? pendingBadge;

                  if (state is HubRequestsLoaded) {
                    final pendingCount = state.requests.where((r) => r.status == 'pending').length;
                    if (pendingCount > 0) {
                      pendingBadge = pendingCount.toString();
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.dashboard,
                        label: 'Dashboard',
                        route: AppRoutes.dashboardHome,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.store,
                        label: 'Hub Requests',
                        route: AppRoutes.dashboardHubRequests,
                        badge: pendingBadge,
                      ),
                      _buildMenuItem(context, icon: Icons.people, label: 'Users', route: AppRoutes.dashboardUsers),
                      _buildMenuItem(
                        context,
                        icon: Icons.receipt_long,
                        label: 'Transactions',
                        route: AppRoutes.dashboardTransactions,
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.settings,
                        label: 'Settings',
                        route: AppRoutes.dashboardSettings,
                      ),
                    ],
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // Theme Toggle
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.brightness_6, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 12),
                  Text('Theme', style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  Switch(
                    value: context.watch<ThemeProvider>().isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // User Section
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String userEmail = 'Admin';
                if (state is AuthAuthenticated) {
                  userEmail = state.user.email ?? 'Admin';
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(userEmail[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userEmail,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Super Admin',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 20),
                        tooltip: 'Logout',
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    String? badge,
  }) {
    final theme = Theme.of(context);
    final isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // Only navigate if not already on this route
            final didNavigate = NavigationHelper.navigateToIfNotCurrent(context, route);

            // Close drawer on mobile if navigation occurred
            if (didNavigate && MediaQuery.of(context).size.width < 768) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
