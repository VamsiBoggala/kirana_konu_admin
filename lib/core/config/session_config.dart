/// Session timeout configuration
///
/// For TESTING: Change timeout to 1 minute
/// For PRODUCTION: Use 15 minutes

class SessionConfig {
  /// Session timeout duration
  ///
  /// Change this to test the session timeout feature:
  /// - Duration(seconds: 30) for quick testing (30 seconds)
  /// - Duration(minutes: 1) for quick testing (1 minute)I We
  /// - Duration(minutes: 15) for production (15 minutes)
  static const Duration timeoutDuration = Duration(minutes: 15);

  /// Enable debug logging for session timer
  static const bool enableDebugLogs = true;
}
