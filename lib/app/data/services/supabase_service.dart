import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase client and auth state.
/// Use Get.find<SupabaseService>() to access.
class SupabaseService extends GetxService {
  SupabaseClient get client => Supabase.instance.client;

  /// Current session (null if not logged in)
  Session? get currentSession => client.auth.currentSession;

  /// Whether user is authenticated
  bool get isAuthenticated => currentSession != null;

  /// Current user from Supabase Auth
  User? get authUser => client.auth.currentUser;

  /// Sign out and clear session
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
