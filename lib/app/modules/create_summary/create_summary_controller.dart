import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';

class CreateSummaryController extends GetxController {
  final subjects = <SubjectModel>[].obs;
  final chapters = <ChapterModel>[].obs;

  final selectedSubject = Rxn<SubjectModel>();
  final selectedChapter = Rxn<ChapterModel>();

  final isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    subjects.value = MockDataService.getMockSubjects();
  }

  void selectSubject(SubjectModel subject) {
    selectedSubject.value = subject;
    selectedChapter.value = null;
    _loadChapters(subject.id);
  }

  Future<void> _loadChapters(String subjectId) async {
    chapters.value = MockDataService.getMockChapters(subjectId);
  }

  void selectChapter(ChapterModel chapter) {
    selectedChapter.value = chapter;
  }

  Future<void> generateSummary() async {
    if (selectedSubject.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار المادة');
      return;
    }

    if (selectedChapter.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار الفصل');
      return;
    }

    isGenerating.value = true;

    await Future.delayed(const Duration(seconds: 3));

    final summaryData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'summary',
      'title': 'ملخص: ${selectedChapter.value!.name}',
      'subject': selectedSubject.value!.name,
      'chapter': selectedChapter.value!.name,
      'date': DateTime.now(),
      'content':
          '''
# ${selectedChapter.value!.name}

## النقاط الرئيسية:

• النقطة الأولى: شرح مفصل للمفهوم الأول...
• النقطة الثانية: شرح مفصل للمفهوم الثاني...
• النقطة الثالثة: شرح مفصل للمفهوم الثالث...

## الأمثلة المهمة:

مثال 1: ...
مثال 2: ...

## ملاحظات مهمة:

⚠️ تذكر أن...
💡 نصيحة: ...

---
هذا الملخص تم إنشاؤه بواسطة AI
      ''',
    };

    isGenerating.value = false;

    Helpers.showSuccessSnackbar('تم إنشاء الملخص بنجاح');

    Get.offAndToNamed(AppRoutes.SUMMARY_DETAIL, arguments: summaryData);
  }
}
