import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/supabase_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final rawCode = passwordController.text.trim();

      // ✅ تحويل الكود لـ 6 أحرف قبل الإرسال
      // 1001 → 001001
      final password = rawCode.padLeft(6, '0');

      await _supabaseService.signInWithPassword(
        email: email,
        password: password,
      );

      // جلب بيانات الطالب
      final response = await _supabaseService.client.rpc('get_student_profile');

      UserModel user;

      if (response != null) {
        try {
          final Map<String, dynamic> profileData = Map<String, dynamic>.from(
            response as Map,
          );
          user = UserModel.fromStudentProfile(profileData);
        } catch (parseError) {
          user = _buildFallbackUser(email);
        }
      } else {
        user = _buildFallbackUser(email);
      }

      await _storageService.saveUser(user);

      Helpers.showSuccessSnackbar('تم تسجيل الدخول بنجاح');
      Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
    } catch (e) {
      final message = e.toString();
      if (message.contains('Invalid login credentials')) {
        Helpers.showErrorSnackbar('الرمز أو البريد الإلكتروني غير صحيح');
      } else if (message.contains('Email not confirmed')) {
        Helpers.showErrorSnackbar('الرجاء تأكيد البريد الإلكتروني');
      } else {
        Helpers.showErrorSnackbar('حدث خطأ أثناء تسجيل الدخول. حاول مرة أخرى.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  UserModel _buildFallbackUser(String email) {
    final userName = email
        .split('@')[0]
        .replaceAll('.', ' ')
        .replaceAll('_', ' ');
    return UserModel(
      id: '',
      name: userName
          .split(' ')
          .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
          .join(' ')
          .trim(),
      email: email,
      avatar:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=6C63FF&color=fff&size=200',
      createdAt: DateTime.now(),
    );
  }

  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      Helpers.showErrorSnackbar('الرجاء إدخال البريد الإلكتروني');
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Helpers.showErrorSnackbar('الرجاء إدخال بريد إلكتروني صحيح');
      return false;
    }
    if (passwordController.text.isEmpty) {
      Helpers.showErrorSnackbar('الرجاء إدخال الرمز');
      return false;
    }
    // ✅ الحد الأدنى 4 أحرف (student_code)
    if (passwordController.text.trim().length < 4) {
      Helpers.showErrorSnackbar(
        'الرجاء إدخال رمزك المكون من 4 أرقام على الأقل',
      );
      return false;
    }
    return true;
  }
}
