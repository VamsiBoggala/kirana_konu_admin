import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/services/auth_service.dart';
import 'core/widgets/session_guard.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/network/bloc/network_bloc.dart';
import 'core/network/bloc/network_event.dart';
import 'core/network/widgets/network_banner.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/home_screen.dart';
import 'features/hub_requests/screens/hub_requests_screen.dart';

import 'features/hub_requests/screens/hub_request_detail_screen.dart';
import 'features/hub_requests/models/hub_request_model.dart';
import 'core/routes/app_routes.dart';

// Global navigator key for navigation without context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AuthBloc(authService: AuthService())..add(AuthCheckRequested())),
              BlocProvider(create: (context) => NetworkBloc()..add(const StartNetworkMonitoring())),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey, // Global navigator key
              title: 'Kirana Konu - Admin Panel',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              builder: (context, child) {
                // Global auth listener that works regardless of current route
                return BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      // Use post-frame callback to ensure navigation happens after build
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (navigatorKey.currentState != null) {
                          final currentRoute = navigatorKey.currentState!.overlay?.context != null
                              ? ModalRoute.of(navigatorKey.currentState!.overlay!.context)?.settings.name
                              : null;

                          // Only navigate if not already on dashboard routes
                          if (currentRoute != AppRoutes.dashboardHome && currentRoute != AppRoutes.dashboard) {
                            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                              AppRoutes.dashboardHome,
                              (route) => false,
                            );
                          }
                        }
                      });
                    } else if (state is AuthUnauthenticated) {
                      // Use post-frame callback to ensure navigation happens after build
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (navigatorKey.currentState != null) {
                          final currentRoute = navigatorKey.currentState!.overlay?.context != null
                              ? ModalRoute.of(navigatorKey.currentState!.overlay!.context)?.settings.name
                              : null;

                          // Only navigate if not already on login or root
                          if (currentRoute != AppRoutes.login && currentRoute != '/') {
                            navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                          }
                        }
                      });
                    }
                  },
                  child: child!,
                );
              },
              routes: {
                '/': (context) => const NetworkBanner(child: AuthNavigator()),
                AppRoutes.login: (context) => const LoginScreen(),
                AppRoutes.dashboard: (context) => _buildAuthenticatedScreen(context, const HomeScreen()),
                AppRoutes.dashboardHome: (context) => _buildAuthenticatedScreen(context, const HomeScreen()),
                AppRoutes.dashboardHubRequests: (context) =>
                    _buildAuthenticatedScreen(context, const HubRequestsScreen()),
                AppRoutes.dashboardHubRequestDetail: (context) {
                  final request = ModalRoute.of(context)!.settings.arguments as HubRequest;
                  return _buildAuthenticatedScreen(context, HubRequestDetailScreen(request: request));
                },
                AppRoutes.dashboardUsers: (context) =>
                    _buildAuthenticatedScreen(context, const _PlaceholderScreen(title: 'Users')),
                AppRoutes.dashboardTransactions: (context) =>
                    _buildAuthenticatedScreen(context, const _PlaceholderScreen(title: 'Transactions')),
                AppRoutes.dashboardSettings: (context) =>
                    _buildAuthenticatedScreen(context, const _PlaceholderScreen(title: 'Settings')),
              },
              initialRoute: '/',
            ),
          );
        },
      ),
    );
  }
}

/// Helper function to wrap authenticated screens with SessionGuard
Widget _buildAuthenticatedScreen(BuildContext context, Widget child) {
  return SessionGuard(
    onTimeout: () {
      print('🚨 Session timeout callback triggered');

      // Use navigatorKey to get a valid context
      final currentContext = navigatorKey.currentContext;
      if (currentContext == null) {
        print('❌ Error: navigatorKey.currentContext is null');
        return;
      }

      print('✅ Current context is valid, triggering logout');

      // Auto-logout on session timeout
      currentContext.read<AuthBloc>().add(AuthLogoutRequested());

      // Show snackbar notification
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(
          content: Text('Session expired due to inactivity'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
        ),
      );
    },
    child: child,
  );
}

/// Navigator that switches between login and authenticated screens
class AuthNavigator extends StatefulWidget {
  const AuthNavigator({super.key});

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Only navigate on definitive states, not on AuthInitial or AuthLoading
        if (state is AuthAuthenticated) {
          // Use post-frame callback to ensure proper navigation timing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && navigatorKey.currentState != null) {
              // Clear all previous routes when navigating to home after authentication
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                AppRoutes.dashboardHome,
                (route) => false, // Remove all previous routes
              );
            }
          });
        } else if (state is AuthUnauthenticated) {
          // Use post-frame callback to ensure proper navigation timing
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && navigatorKey.currentState != null) {
              // Clear all routes and navigate to login
              navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            }
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Checking authentication...', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder screen for unimplemented pages
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text('$title Page', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
