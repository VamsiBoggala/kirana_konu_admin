import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kirana_admin_web/core/constants/app_colors.dart';
import '../bloc/network_bloc.dart';
import '../bloc/network_state.dart';

/// Network Banner Widget
/// Displays a banner at the top of the screen when there's no internet connection
class NetworkBanner extends StatelessWidget {
  final Widget child;

  const NetworkBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            // Show banner only when disconnected
            if (state is NetworkDisconnected) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: AppColors.error,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: AppColors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No Internet Connection',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }

            // Don't show banner when connected
            return const SizedBox.shrink();
          },
        ),
        Expanded(child: child),
      ],
    );
  }
}
