// import 'package:get/get.dart';
// import '../../data/services/storage_service.dart';
// import '../../routes/app_routes.dart';

// class SplashController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     print("SplashController initialized");
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     print("SplashController ready");
//     _navigateToNextScreen();
//   }

//   Future<void> _navigateToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 2));

//     try {
//       final storageService = Get.find<StorageService>();
//       // isLoggedIn now checks Supabase session
//       final isLoggedIn = storageService.isLoggedIn;

//       if (isLoggedIn) {
//         Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
//       } else {
//         Get.offAllNamed(AppRoutes.LOGIN);
//       }
//     } catch (e) {
//       Get.offAllNamed(AppRoutes.LOGIN);
//     }
//   }
// }
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // ✅ أضفنا هذا
import '../../core/services/student_push_notifications_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashController initialized");
  }

  @override
  void onReady() {
    super.onReady();
    print("SplashController ready");
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // ✅ أولاً: تحقق هل شاف الـ Onboarding من قبل
      final bool onboardingDone = GetStorage().read('onboarding_done') ?? false;

      if (!onboardingDone) {
        // أول مرة يفتح التطبيق → روّحه للـ Onboarding
        Get.offAllNamed(AppRoutes.ONBOARDING);
        return;
      }

      // ✅ ثانياً: إذا شاف الـ Onboarding، تحقق من الـ Login
      final storageService = Get.find<StorageService>();
      final isLoggedIn = storageService.isLoggedIn;

      if (isLoggedIn) {
        await Get.find<StudentPushNotificationsService>().registerCurrentDeviceToken();
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Get.find<StudentPushNotificationsService>().handleInitialMessageIfAny();
        });
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
