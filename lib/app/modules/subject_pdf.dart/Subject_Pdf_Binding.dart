import 'package:get/get.dart';
import 'package:quiz_master_app/app/modules/subject_pdf.dart/subject_pdf_controller.dart';

class SubjectPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectPdfController>(() => SubjectPdfController());
  }
}
