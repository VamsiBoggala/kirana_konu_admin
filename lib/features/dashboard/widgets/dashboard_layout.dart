import 'package:flutter/material.dart';
import 'package:kirana_admin_web/main_navigator.dart';
import 'admin_sidebar.dart';

/// Main dashboard layout with sidebar and content area
class DashboardLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const DashboardLayout({super.key, required this.child, this.currentRoute = '/dashboard'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar (desktop only)
          if (MediaQuery.of(context).size.width >= 768) AdminSidebar(currentRoute: currentRoute),

          // Main Content Area
          Expanded(
            child: Container(color: Theme.of(context).colorScheme.background, child: child),
          ),
        ],
      ),
      // Drawer for mobile
      drawer: MediaQuery.of(context).size.width < 768 ? Drawer(child: AdminSidebar(currentRoute: currentRoute)) : null,
    );
  }
}
