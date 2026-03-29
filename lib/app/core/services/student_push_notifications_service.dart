import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/services/storage_service.dart';
import 'package:quiz_master_app/app/data/services/supabase_service.dart';
import 'package:quiz_master_app/app/modules/notifications/notifications_controller.dart';
import 'package:quiz_master_app/app/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// تسجيل رمز FCM في `user_devices` وعرض إشعارات الاختبارات المخصصة من المعلم.
class StudentPushNotificationsService extends GetxService {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _examChannel =
      AndroidNotificationChannel(
        'exam_assignments',
        'اختبارات المعلم',
        description: 'إشعار عند إسناد اختبار جديد',
        importance: Importance.max,
      );

  Future<void> init() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestPermissions();
    await registerCurrentDeviceToken();
    _configureOpenHandlers();

    FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
      await _upsertToken(t);
    });

    FirebaseMessaging.onMessage.listen((message) async {
      final n = message.notification;
      final title = n?.title ?? 'اختبار جديد';
      final body = n?.body ?? '';
      await _local.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: jsonEncode(message.data),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _examChannel.id,
            _examChannel.name,
            channelDescription: _examChannel.description,
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(body),
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _openNotificationsFromPayload(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_examChannel);
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {}

  Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureOpenHandlers() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openNotificationsFromData(message.data);
    });
  }

  /// بعد اكتمال الـ splash ووجود جلسة — إعادة تسجيل الرمز.
  Future<void> registerCurrentDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await _upsertToken(token);
    } catch (e) {
      debugPrint('⚠️ registerCurrentDeviceToken: $e');
    }
  }

  Future<void> handleInitialMessageIfAny() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _openNotificationsFromData(initial.data);
    }
  }

  Future<void> _upsertToken(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    final profile = _storage.user;
    if (user == null || profile == null) return;

    final studentId = int.tryParse(profile.id);
    if (studentId == null || studentId <= 0) return;

    final platform = Platform.isAndroid ? 'android' : 'ios';

    try {
      await _supabase.client.from('user_devices').upsert({
        'auth_user_id': user.id,
        'user_type': 'student',
        'app_entity_id': studentId,
        'platform': platform,
        'fcm_token': token,
        'is_active': true,
        'last_seen_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'auth_user_id,platform');
      debugPrint('✅ FCM token saved for student id=$studentId');
    } catch (e) {
      debugPrint('⚠️ user_devices upsert failed: $e');
    }
  }

  void _openNotificationsFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      _navigateToNotificationsScreen();
      return;
    }
    try {
      final map = jsonDecode(payload);
      if (map is Map) {
        _openNotificationsFromData(Map<String, dynamic>.from(map));
        return;
      }
    } catch (_) {}
    _navigateToNotificationsScreen();
  }

  void _openNotificationsFromData(Map<String, dynamic> data) {
    _navigateToNotificationsScreen();
  }

  /// يفتح شاشة الإشعارات (نفس وجهة الضغط على إشعار FCM).
  void _navigateToNotificationsScreen() {
    if (Get.currentRoute == AppRoutes.NOTIFICATIONS) return;

    final onMain = Get.currentRoute == AppRoutes.MAIN_NAVIGATION;
    if (!onMain) {
      Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(AppRoutes.NOTIFICATIONS);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshNotificationsIfPossible();
        });
      });
      return;
    }

    Get.toNamed(AppRoutes.NOTIFICATIONS);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshNotificationsIfPossible();
    });
  }

  void _refreshNotificationsIfPossible() {
    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().loadNotifications();
    }
  }
}
