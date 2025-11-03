import 'package:get/get.dart';
import 'create_summary_controller.dart';

class CreateSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateSummaryController>(() => CreateSummaryController());
  }
}
