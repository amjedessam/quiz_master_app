import 'package:get/get.dart';

import '../../core/utils/helpers.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_routes.dart';

class CreateSummaryController extends GetxController {
  final SubjectRepository _subjectRepo  = Get.find<SubjectRepository>();
  final SupabaseService   _supabase     = Get.find<SupabaseService>();

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
    try {
      subjects.value = await _subjectRepo.getSubjectsWithStats();
    } catch (_) {
      subjects.value = [];
    }
  }

  void selectSubject(SubjectModel subject) {
    selectedSubject.value = subject;
    selectedChapter.value = null;
    final subjectId = int.tryParse(subject.id);
    if (subjectId != null) {
      _loadChapters(subjectId);
    }
  }

  Future<void> _loadChapters(int subjectId) async {
    try {
      chapters.value = await _subjectRepo.getChaptersWithProgress(subjectId);
    } catch (_) {
      chapters.value = [];
    }
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

    final subjectId = int.tryParse(selectedSubject.value!.id);
    final chapterId = int.tryParse(selectedChapter.value!.id);
    if (subjectId == null || chapterId == null) {
      Helpers.showErrorSnackbar('بيانات غير صالحة');
      return;
    }

    isGenerating.value = true;

    // Build summary template (V1 — local generation, to be replaced by AI later)
    final title   = 'ملخص: ${selectedChapter.value!.name}';
    final content = '''
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
''';

    try {
      // Persist to Supabase student_summaries
      final newId = await _supabase.client.rpc(
        'create_student_summary',
        params: {
          'p_subject_id':   subjectId,
          'p_chapter_id':   chapterId,
          'p_title':        title,
          'p_content':      content,
          'p_summary_type': 'summary',
        },
      );

      isGenerating.value = false;
      Helpers.showSuccessSnackbar('تم إنشاء الملخص وحفظه بنجاح');

      // Navigate to summary detail view
      Get.offAndToNamed(
        AppRoutes.SUMMARY_DETAIL,
        arguments: {
          'id':      newId?.toString() ?? '',
          'type':    'summary',
          'title':   title,
          'subject': selectedSubject.value!.name,
          'chapter': selectedChapter.value!.name,
          'date':    DateTime.now(),
          'content': content,
        },
      );
    } catch (_) {
      isGenerating.value = false;
      Helpers.showErrorSnackbar('فشل حفظ الملخص. حاول مرة أخرى.');
    }
  }
}
