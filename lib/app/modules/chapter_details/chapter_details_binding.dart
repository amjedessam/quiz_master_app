import 'package:get/get.dart';
import 'chapter_details_controller.dart';

class ChapterDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChapterDetailsController>(() => ChapterDetailsController());
  }
}
