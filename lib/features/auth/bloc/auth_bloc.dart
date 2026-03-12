import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService}) : _authService = authService, super(AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    // Listen to Firebase auth state changes
    _authService.authStateChanges.listen((user) {
      // Always trigger auth check when Firebase state changes
      // This will properly emit states through the event handler
      add(AuthCheckRequested());
    });
  }

  /// Handle authentication status check
  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final User? user = _authService.currentUser;

    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Handle login request
  Future<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User user = await _authService.loginWithEmailPassword(email: event.email, password: event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  /// Handle logout request
  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}
