import 'package:get/get.dart';
import 'quiz_setup_controller.dart';

class QuizSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizSetupController>(() => QuizSetupController());
  }
}
