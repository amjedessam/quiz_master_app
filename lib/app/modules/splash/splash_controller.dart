import 'package:get/get.dart';
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
    print("starting navigation delay...");

    await Future.delayed(const Duration(seconds: 2));
    print("3 seconds completed.");
    try {
      final storageService = Get.find<StorageService>();
      final isLoggedIn = storageService.isLoggedIn;

      print(' Is logged in: $isLoggedIn');

      if (isLoggedIn) {
        print(' Navigating to HOME');
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        print(' Navigating to LOGIN');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print(' Error: $e');
      // في حالة الخطأ، اذهب للـ Login
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
