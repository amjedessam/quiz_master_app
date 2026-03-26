import 'package:get/get.dart';
import 'package:quiz_master_app/app/modules/assigned_exams/assigned_exams_controller.dart';

class AssignedExamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignedExamsController>(() => AssignedExamsController());
  }
}
