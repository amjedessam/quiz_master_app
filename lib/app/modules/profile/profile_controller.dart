import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final user = Rxn<UserModel>();
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storageService.user;
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
    Helpers.showSuccessSnackbar(
      notificationsEnabled.value ? 'تم تفعيل الإشعارات' : 'تم إيقاف الإشعارات',
    );
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Helpers.showSuccessSnackbar(
      isDarkMode.value ? 'تم تفعيل الوضع الليلي' : 'تم إيقاف الوضع الليلي',
    );
  }

  void editProfile() {
    Helpers.showSuccessSnackbar('هذه الميزة قريباً');
  }

  void changePassword() {
    Helpers.showSuccessSnackbar('هذه الميزة قريباً');
  }

  void aboutApp() {
    Get.dialog(
      AlertDialog(
        title: const Text('عن التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quiz Master'),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            const Text('تطبيق الاختبارات الذكي للطلاب'),
            const SizedBox(height: 16),
            const Text(
              'تم التطوير بواسطة المبرمج  Amjed Mashreh',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('حسناً')),
        ],
      ),
    );
  }

  void contactSupport() {
    Get.dialog(
      AlertDialog(
        title: const Text('مركز المساعدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('للتواصل مع المدرس :774353045'),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            const Text("للتواصل مع المدرسة : 774353045"),
            const SizedBox(height: 16),
            const Text(
              'للتواصل مع المطور :774353045',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('حسناً')),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _storageService.clearAll();
      Helpers.showSuccessSnackbar('تم تسجيل الخروج بنجاح');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
