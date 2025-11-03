import 'package:get/get.dart';
import 'summary_detail_controller.dart';

class SummaryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SummaryDetailController>(() => SummaryDetailController());
  }
}
