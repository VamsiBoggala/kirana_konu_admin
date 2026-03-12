import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling authentication operations
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Login with email and password
  /// Returns user if login successful and role is verified
  /// Throws exception if login fails or role is not super_admin
  Future<User> loginWithEmailPassword({required String email, required String password}) async {
    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw Exception('Login failed - no user returned');
      }

      // Verify user role in Firestore
      final bool isAdmin = await _verifyAdminRole(user.uid);
      if (!isAdmin) {
        // Logout immediately if not admin
        await logout();
        throw Exception('Access Denied - Invalid role');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify if user has super_admin role
  Future<bool> _verifyAdminRole(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('admin_users').doc(uid).get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>?;
      return data?['role'] == 'super_admin';
    } catch (e) {
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Login failed: ${e.message ?? 'Unknown error'}';
    }
  }
}
