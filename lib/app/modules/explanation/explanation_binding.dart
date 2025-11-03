import 'package:get/get.dart';
import 'explanation_controller.dart';

class ExplanationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExplanationController>(() => ExplanationController());
  }
}
