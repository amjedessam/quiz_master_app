import 'package:get/get.dart';
import 'summaries_controller.dart';

class SummariesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SummariesController>(() => SummariesController());
  }
}
