import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

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

    await Future.delayed(const Duration(seconds: 2));

    final email = emailController.text.trim();

    final userName = email
        .split('@')[0]
        .replaceAll('.', ' ')
        .replaceAll('_', ' ');

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: userName
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' '),
      email: email,
      avatar:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=6C63FF&color=fff&size=200',
      createdAt: DateTime.now(),
    );

    await _storageService.saveUser(user);
    await _storageService.saveToken('token_${user.id}');
    await _storageService.setLoggedIn(true);

    isLoading.value = false;

    Helpers.showSuccessSnackbar('تم تسجيل الدخول بنجاح');
    Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
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
      Helpers.showErrorSnackbar('الرجاء إدخال كلمة المرور');
      return false;
    }

    if (passwordController.text.length < 6) {
      Helpers.showErrorSnackbar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return false;
    }

    return true;
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }
}
