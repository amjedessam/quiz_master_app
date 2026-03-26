import 'package:get/get.dart';

import '../../data/models/chapter_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/subject_repository.dart';
import '../../routes/app_routes.dart';

class SubjectDetailsController extends GetxController {
  final SubjectRepository _subjectRepo = Get.find<SubjectRepository>();

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

    try {
      final subjectId = int.tryParse(subject.value!.id);
      if (subjectId != null) {
        chapters.value =
            await _subjectRepo.getChaptersWithProgress(subjectId);
      }
    } catch (e) {
      chapters.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void startQuiz(ChapterModel chapter) {
    Get.toNamed(
      AppRoutes.CHAPTER_DETAILS,
      arguments: {'subject': subject.value, 'chapter': chapter},
    );
  }

  Future<void> refreshData() async {
    await _loadChapters();
  }
}
