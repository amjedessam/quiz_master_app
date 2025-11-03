import 'package:get/get.dart';
import '../../data/services/storage_service.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<SplashController>(SplashController());
  }
}
