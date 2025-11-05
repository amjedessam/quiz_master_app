import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

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

    await Future.delayed(const Duration(seconds: 2));

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      avatar:
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nameController.text.trim())}&background=6C63FF&color=fff&size=200',
      createdAt: DateTime.now(),
    );

    await _storageService.saveUser(newUser);
    await _storageService.saveToken('token_${newUser.id}');
    await _storageService.setLoggedIn(true);

    isLoading.value = false;

    Helpers.showSuccessSnackbar('تم إنشاء الحساب بنجاح');
    Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
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
