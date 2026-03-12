// import 'package:flutter/material.dart';
// import '../../features/auth/screens/login_screen.dart';
// import '../../features/dashboard/screens/home_screen.dart';
// import '../../features/hub_requests/screens/hub_requests_screen.dart';
// import '../../features/hub_requests/screens/hub_request_detail_screen.dart';
// import '../../features/hub_requests/models/hub_request_model.dart';
// import 'app_routes.dart';

// /// Route generator for the app
// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AppRoutes.login:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());

//       case AppRoutes.dashboard:
//         return MaterialPageRoute(builder: (_) => const HomeScreen());

//       case AppRoutes.hubRequests:
//         return MaterialPageRoute(builder: (_) => const HubRequestsScreen());

//       case AppRoutes.hubRequestDetail:
//         final request = settings.arguments as HubRequest;
//         return MaterialPageRoute(builder: (_) => HubRequestDetailScreen(request: request));

//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(
//       builder: (_) => Scaffold(
//         appBar: AppBar(title: const Text('Error')),
//         body: const Center(child: Text('Page not found')),
//       ),
//     );
//   }
// }
