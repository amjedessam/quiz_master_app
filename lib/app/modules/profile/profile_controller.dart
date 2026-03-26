import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_model.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/supabase_service.dart';
import '../../data/repositories/practice_quiz_repository.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../core/theme/app_colors.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final PracticeQuizRepository _practiceRepo =
      Get.find<PracticeQuizRepository>();

  final user = Rxn<UserModel>();
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;
  final isUploadingAvatar = false.obs;

  // إحصائيات حقيقية
  final totalQuizzes = 0.obs;
  final averageScore = 0.0.obs;
  final streakDays = 0.obs;
  final isLoadingStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _storageService.user;
    fetchStatistics();
  }

  // ← رفع صورة المستخدم
  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();

    // اختيار مصدر الصورة
    final source = await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('اختر مصدر الصورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('من المعرض'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('من الكاميرا'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    try {
      isUploadingAvatar.value = true;

      final file = File(pickedFile.path);
      final userId = _supabaseService.client.auth.currentUser?.id;
      if (userId == null) return;

      // اسم الملف
      final fileName = 'avatar_$userId.jpg';

      // رفع الصورة لـ Supabase Storage
      await _supabaseService.client.storage
          .from('user-profiles')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true, // استبدال إذا موجود
            ),
          );

      // جلب الرابط العام
      final avatarUrl = _supabaseService.client.storage
          .from('user-profiles')
          .getPublicUrl(fileName);

      // تحديث في جدول students
      await _supabaseService.client
          .from('students')
          .update({'profile_image_url': avatarUrl})
          .eq('id', user.value!.id);

      // تحديث الـ UserModel محلياً
      final updatedUser = UserModel(
        id: user.value!.id,
        name: user.value!.name,
        email: user.value!.email,
        avatar: avatarUrl,
        createdAt: user.value!.createdAt,
      );

      user.value = updatedUser;
      await _storageService.saveUser(updatedUser);

      Helpers.showSuccessSnackbar('تم تحديث الصورة الشخصية بنجاح');
    } catch (e) {
      print('❌ Avatar upload error: $e');
      Helpers.showErrorSnackbar('فشل رفع الصورة. حاول مجدداً.');
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  // جلب الإحصائيات الحقيقية من قاعدة البيانات
  Future<void> fetchStatistics() async {
    isLoadingStats.value = true;
    try {
      final analytics = await _practiceRepo.getAnalytics();

      totalQuizzes.value = (analytics['totalQuizzes'] as num?)?.toInt() ?? 0;
      averageScore.value =
          (analytics['averageScore'] as num?)?.toDouble() ?? 0.0;
      streakDays.value = (analytics['streakDays'] as num?)?.toInt() ?? 0;
    } catch (e) {
      print('❌ Error fetching statistics: $e');
      // قيم افتراضية في حالة الخطأ
      totalQuizzes.value = 0;
      averageScore.value = 0.0;
      streakDays.value = 0;
    } finally {
      isLoadingStats.value = false;
    }
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
            const Text('تطبيق الاختبارات الذكي للطلاب'),
            const SizedBox(height: 16),
            const Text(
              'تم التطوير بواسطة المبرمج Amjed Mashreh',
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
            const Text('للتواصل مع المدرس: 774353045'),
            const SizedBox(height: 8),
            const Text('للتواصل مع المدرسة: 774353045'),
            const SizedBox(height: 16),
            const Text(
              'للتواصل مع المطور: 774353045',
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
