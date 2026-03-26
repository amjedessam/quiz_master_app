import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import 'supabase_service.dart';

/// Handles auth state and user profile.
/// Uses Supabase for session; caches user profile in GetStorage for offline access.
class StorageService extends GetxService {
  late final GetStorage _storage;
  static const String _userKey = 'user_data';

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
  }

  SupabaseService get _supabase => Get.find<SupabaseService>();

  /// Whether user is logged in (Supabase session exists)
  bool get isLoggedIn => _supabase.isAuthenticated;

  /// Cached user profile (from students table via get_student_profile)
  UserModel? get user {
    try {
      final userData = _storage.read<Map<String, dynamic>>(_userKey);
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
    } catch (e) {
      print('Error reading user: $e');
    }
    return null;
  }

  Future<void> saveUser(UserModel user) =>
      _storage.write(_userKey, user.toJson());

  Future<void> removeUser() => _storage.remove(_userKey);

  /// Clear all local data and sign out from Supabase
  Future<void> clearAll() async {
    await _storage.erase();
    await _supabase.signOut();
  }
}
