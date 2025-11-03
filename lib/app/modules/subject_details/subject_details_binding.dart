import 'package:get/get.dart';
import 'subject_details_controller.dart';

class SubjectDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectDetailsController>(() => SubjectDetailsController());
  }
}
