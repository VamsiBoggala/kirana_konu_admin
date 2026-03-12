import 'dart:async';
import '../config/session_config.dart';

/// Service for managing session inactivity timeout
class SessionTimerService {
  static final SessionTimerService _instance = SessionTimerService._internal();
  factory SessionTimerService() => _instance;
  SessionTimerService._internal();

  Timer? _timer;
  VoidCallback? _onTimeout;
  bool _isInitialized = false;

  /// Initialize the session timer with a timeout callback
  void initialize(VoidCallback onTimeout) {
    if (_isInitialized) {
      if (SessionConfig.enableDebugLogs) {
        print('⚠️  Session Timer: Already initialized, skipping...');
      }
      return;
    }

    _onTimeout = onTimeout;
    _isInitialized = true;
    _startTimer();
    if (SessionConfig.enableDebugLogs) {
      print('🔒 Session Timer: Initialized with ${SessionConfig.timeoutDuration.inMinutes} minute timeout');
    }
  }

  /// Reset the timer (called on user activity)
  void resetTimer() {
    if (!_isInitialized) return;

    _timer?.cancel();
    _startTimer();
    if (SessionConfig.enableDebugLogs) {
      print('🔄 Session Timer: Reset - User activity detected');
    }
  }

  /// Start or restart the timer
  void _startTimer() {
    if (SessionConfig.enableDebugLogs) {
      final now = DateTime.now();
      final timeoutAt = now.add(SessionConfig.timeoutDuration);
      print(
        '⏱️  Session Timer: Started - Will timeout at ${timeoutAt.hour}:${timeoutAt.minute.toString().padLeft(2, '0')}:${timeoutAt.second.toString().padLeft(2, '0')}',
      );
      print('📌 Callback is: ${_onTimeout == null ? "NULL" : "SET"}');
    }

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer(SessionConfig.timeoutDuration, () {
      if (SessionConfig.enableDebugLogs) {
        print('⏰ Session Timer: TIMEOUT! Triggering auto-logout...');
        print('📌 About to call callback. Callback is: ${_onTimeout == null ? "NULL" : "SET"}');
      }

      if (_onTimeout == null) {
        print('❌ ERROR: Callback is null, cannot trigger logout!');
        return;
      }

      try {
        _onTimeout!();
        print('✅ Callback executed successfully');
      } catch (e, stack) {
        print('❌ ERROR calling callback: $e');
        print('Stack trace: $stack');
      }
    });
  }

  /// Cancel the timer (called on logout)
  void dispose() {
    if (SessionConfig.enableDebugLogs) {
      print('🛑 Session Timer: Disposed');
    }
    _timer?.cancel();
    _timer = null;
    _onTimeout = null;
    _isInitialized = false;
  }
}

typedef VoidCallback = void Function();
