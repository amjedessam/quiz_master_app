import 'package:get/get.dart';
import 'home_controller.dart';
import '../notifications/notifications_controller.dart'; // ✅ إضافة

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    ); // ✅ إضافة
  }
}
