import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking authentication
class AuthInitial extends AuthState {}

/// Loading state - authentication in progress
class AuthLoading extends AuthState {}

/// Authenticated state - user is logged in with verified role
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user.uid];
}

/// Unauthenticated state - no user logged in
class AuthUnauthenticated extends AuthState {}

/// Error state - authentication or role verification failed
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
