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
    await Future.delayed(const Duration(seconds: 2));

    try {
      final storageService = Get.find<StorageService>();
      // isLoggedIn now checks Supabase session
      final isLoggedIn = storageService.isLoggedIn;

      if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
