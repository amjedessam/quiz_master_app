import 'package:get/get.dart';
import 'ai_quiz_setup_controller.dart';

class AiQuizSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiQuizSetupController>(() => AiQuizSetupController());
  }
}
