import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/supabase_service.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> register() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      await _supabaseService.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {'full_name': nameController.text.trim()},
      );

      Helpers.showSuccessSnackbar(
        'تم التسجيل. يرجى تأكيد البريد الإلكتروني ثم تسجيل الدخول. '
        'إذا كنت طالباً، قد تحتاج لتفعيل حسابك من الإدارة.',
      );
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      final message = e.toString();
      if (message.contains('already registered')) {
        Helpers.showErrorSnackbar('هذا البريد مسجل مسبقاً');
      } else {
        Helpers.showErrorSnackbar('حدث خطأ أثناء التسجيل. حاول مرة أخرى.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Helpers.showErrorSnackbar('الرجاء إدخال الاسم');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Helpers.showErrorSnackbar('الرجاء إدخال البريد الإلكتروني');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Helpers.showErrorSnackbar('الرجاء إدخال بريد إلكتروني صحيح');
      return false;
    }

    if (passwordController.text.isEmpty) {
      Helpers.showErrorSnackbar('الرجاء إدخال كلمة المرور');
      return false;
    }

    if (passwordController.text.length < 6) {
      Helpers.showErrorSnackbar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Helpers.showErrorSnackbar('كلمة المرور غير متطابقة');
      return false;
    }

    return true;
  }

  void goToLogin() {
    Get.back();
  }
}
