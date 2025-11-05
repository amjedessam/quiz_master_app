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
    print('⏳ Starting navigation delay...');

    await Future.delayed(const Duration(seconds: 3));

    print('⏰ 3 seconds completed');

    try {
      final storageService = Get.find<StorageService>();
      final isLoggedIn = storageService.isLoggedIn;

      print('🔐 Is logged in: $isLoggedIn');

      if (isLoggedIn) {
        print('➡️ Navigating to MAIN_NAVIGATION');
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      } else {
        print('➡️ Navigating to LOGIN');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print('❌ Error: $e');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
