// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../models/user_model.dart';

// class StorageService extends GetxService {
//   final _storage = GetStorage();

//   // Keys
//   static const String _tokenKey = 'auth_token';
//   static const String _userKey = 'user_data';
//   static const String _isLoggedInKey = 'is_logged_in';

//   // Token
//   String? get token => _storage.read<String>(_tokenKey);
//   Future<void> saveToken(String token) => _storage.write(_tokenKey, token);
//   Future<void> removeToken() => _storage.remove(_tokenKey);

//   // User
//   UserModel? get user {
//     final userData = _storage.read<Map<String, dynamic>>(_userKey);
//     if (userData != null) {
//       return UserModel.fromJson(userData);
//     }
//     return null;
//   }

//   Future<void> saveUser(UserModel user) =>
//       _storage.write(_userKey, user.toJson());
//   Future<void> removeUser() => _storage.remove(_userKey);

//   // Login Status
//   bool get isLoggedIn => _storage.read<bool>(_isLoggedInKey) ?? false;
//   Future<void> setLoggedIn(bool value) => _storage.write(_isLoggedInKey, value);

//   // Clear all
//   Future<void> clearAll() => _storage.erase();
// }

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class StorageService extends GetxService {
  late final GetStorage _storage;

  // هذه الدالة مهمة جداً!
  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
  }

  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Token
  String? get token => _storage.read<String>(_tokenKey);
  Future<void> saveToken(String token) => _storage.write(_tokenKey, token);
  Future<void> removeToken() => _storage.remove(_tokenKey);

  // User
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

  // Login Status
  bool get isLoggedIn => _storage.read<bool>(_isLoggedInKey) ?? false;
  Future<void> setLoggedIn(bool value) => _storage.write(_isLoggedInKey, value);

  // Clear all
  Future<void> clearAll() => _storage.erase();
}
