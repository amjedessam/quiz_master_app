import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../routes/app_routes.dart';

class SubjectDetailsController extends GetxController {
  final subject = Rxn<SubjectModel>();
  final chapters = <ChapterModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    subject.value = Get.arguments as SubjectModel;
    _loadChapters();
  }

  Future<void> _loadChapters() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    chapters.value = MockDataService.getMockChapters(subject.value!.id);

    isLoading.value = false;
  }

  void startQuiz(ChapterModel chapter) {
    Get.toNamed(
      AppRoutes.MainTabView,
      arguments: {'subject': subject.value, 'chapter': chapter},
    );
  }

  Future<void> refreshData() async {
    await _loadChapters();
  }
}
