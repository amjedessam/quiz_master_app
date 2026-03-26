import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/repositories/assigned_exam_repository.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/notification_model.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_routes.dart';

class NotificationsController extends GetxController {
  final _supabaseService = Get.find<SupabaseService>();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      final response = await _supabaseService.client.rpc(
        'get_student_notifications',
      );

      if (response != null) {
        notifications.value = (response as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        _updateUnreadCount();
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      Helpers.showErrorSnackbar('فشل تحميل الإشعارات');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    try {
      isRefreshing.value = true;
      await loadNotifications();
    } finally {
      isRefreshing.value = false;
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabaseService.client.rpc(
        'mark_notification_read',
        params: {'p_notification_id': int.parse(notificationId)}, // ✅
      );
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        notifications.refresh();
        _updateUnreadCount();
      }
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // تحديث كل الإشعارات غير المقروءة
      final unreadIds = notifications
          .where((n) => !n.isRead)
          .map((n) => n.id)
          .toList();

      for (final id in unreadIds) {
        await markAsRead(id);
      }

      Helpers.showSuccessSnackbar('تم تحديد جميع الإشعارات كمقروءة');
    } catch (e) {
      Helpers.showErrorSnackbar('فشل تحديث الإشعارات');
    }
  }

  void handleNotificationTap(NotificationModel notification) async {
    if (!notification.isRead) markAsRead(notification.id);

    if (notification.type == 'exam_published' && // ✅ القيمة الصحيحة
        notification.assignmentId != null) {
      try {
        final repo = Get.find<AssignedExamRepository>();

        // بناء AssignedExamItem مؤقت من بيانات الإشعار
        final item = AssignedExamItem(
          id: int.parse(notification.assignmentId!),
          examId: 0, // سيُجلب من DB
          examTitle: notification.assignmentTitle ?? 'اختبار من المعلم',
          totalMarks: 0,
          passingMarks: 0,
          durationMinutes: 30,
          subjectId: '0',
          subjectName: notification.subjectName ?? '',
          status: 'pending',
          assignedAt: notification.createdAt,
          dueDate: notification.dueDate,
        );

        // جلب الاختبار الحقيقي من exam_assignments
        final exams = await repo.getAssignedExams();
        final realItem = exams.firstWhereOrNull(
          (e) => e.id == int.parse(notification.assignmentId!),
        );

        if (realItem == null) {
          Helpers.showErrorSnackbar('الاختبار غير متاح أو تم حله مسبقاً');
          return;
        }
        final quiz = await repo.loadExamAsQuiz(realItem);
        Get.toNamed(AppRoutes.QUIZ, arguments: quiz);
      } catch (e) {
        debugPrint('handleNotificationTap error: $e');
        Helpers.showErrorSnackbar('فشل تحميل الاختبار');
      }
    }
  }

  String getNotificationIcon(String type) {
    switch (type) {
      case 'exam_published':
        return '📝'; // ✅
      case 'exam_result':
        return '✅';
      case 'attendance_absent':
        return '⚠️';
      case 'general':
        return '🔔';
      default:
        return '🔔';
    }
  }

  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }
}
