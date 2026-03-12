import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/session_timer_service.dart';

/// Widget that wraps the authenticated app and monitors user activity
/// Automatically logs out user after 15 minutes of inactivity
class SessionGuard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTimeout;

  const SessionGuard({super.key, required this.child, required this.onTimeout});

  @override
  State<SessionGuard> createState() => _SessionGuardState();
}

class _SessionGuardState extends State<SessionGuard> {
  final SessionTimerService _sessionTimer = SessionTimerService();
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _sessionTimer.initialize(widget.onTimeout);

    // Request focus after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _sessionTimer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Handle user activity - reset the session timer
  void _onUserActivity() {
    _sessionTimer.resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Reset timer on any key press
        if (event is KeyDownEvent) {
          _onUserActivity();
        }
      },
      child: Listener(
        onPointerDown: (_) => _onUserActivity(), // Mouse clicks
        onPointerMove: (_) => _onUserActivity(), // Mouse movement
        onPointerHover: (_) => _onUserActivity(), // Mouse hover
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}

typedef VoidCallback = void Function();
