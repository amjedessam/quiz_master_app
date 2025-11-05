import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../core/utils/helpers.dart';

class ExplanationController extends GetxController {
  final mode = ''.obs;
  final subjects = <SubjectModel>[].obs;
  final chapters = <ChapterModel>[].obs;

  final selectedSubject = Rxn<SubjectModel>();
  final selectedChapter = Rxn<ChapterModel>();
  final topicController = TextEditingController();

  final isGenerating = false.obs;
  final explanation = ''.obs;
  final showExplanation = false.obs;

  final weakTopics = <String>[].obs;
  final wrongQuestions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      mode.value = args['mode'] ?? 'manual';

      if (mode.value == 'direct') {
        explanation.value = args['content'] as String;
        showExplanation.value = true;
      } else if (mode.value == 'auto') {
        weakTopics.value = List<String>.from(args['weakTopics'] ?? []);
        wrongQuestions.value = List<Map<String, dynamic>>.from(
          args['wrongQuestions'] ?? [],
        );
        _generateAutoExplanation();
      } else {
        _loadSubjects();
      }
    } else {
      mode.value = 'manual';
      _loadSubjects();
    }
  }

  @override
  void onClose() {
    topicController.dispose();
    super.onClose();
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

  Future<void> requestManualExplanation() async {
    if (selectedSubject.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار المادة');
      return;
    }

    final topic = topicController.text.trim();
    if (topic.isEmpty) {
      Helpers.showErrorSnackbar('الرجاء كتابة الموضوع الذي تريد شرحه');
      return;
    }

    isGenerating.value = true;

    await Future.delayed(const Duration(seconds: 3));

    explanation.value =
        '''
# شرح: $topic

## المفهوم الأساسي:

${selectedSubject.value!.name} - ${selectedChapter.value?.name ?? 'عام'}

$topic هو مفهوم مهم يتطلب الفهم الجيد...

## الشرح التفصيلي:

### أولاً: التعريف
التعريف الدقيق للموضوع...

### ثانياً: الأمثلة
مثال 1: شرح مفصل مع الخطوات...
مثال 2: مثال آخر للتوضيح...

### ثالثاً: النقاط المهمة
• النقطة الأولى: ...
• النقطة الثانية: ...
• النقطة الثالثة: ...

## أمثلة تطبيقية:

### مثال محلول:
المعطيات: ...
المطلوب: ...
الحل: ...

## نصائح للحفظ:
💡 استخدم هذه الطريقة...
💡 تذكر أن...

## تمارين إضافية:
1. تمرين 1: ...
2. تمرين 2: ...

---
تم إنشاء هذا الشرح بواسطة AI
    ''';

    isGenerating.value = false;
    showExplanation.value = true;
  }

  Future<void> _generateAutoExplanation() async {
    isGenerating.value = true;

    await Future.delayed(const Duration(seconds: 2));

    final topics = weakTopics.join('، ');

    explanation.value =
        '''
# شرح نقاط الضعف في الاختبار

## المواضيع التي تحتاج مراجعة:
$topics

## تحليل أخطائك:

لقد واجهت صعوبة في ${wrongQuestions.length} سؤال/أسئلة.
دعنا نشرح هذه المواضيع بالتفصيل...

${wrongQuestions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final question = entry.value;
          return '''

---

### السؤال $index:
${question['content']}

❌ إجابتك: ${question['userAnswer'] ?? 'لم تجب'}
✅ الإجابة الصحيحة: ${question['correctAnswer']}

#### الشرح:
${question['explanation']}#### نقاط مهمة:
• راجع ${question['referencePage'] ?? 'الكتاب'}
• هذا السؤال يقيس مهارة: ${_getSkillLabel(question['skill'])}
• مستوى الصعوبة: ${_getDifficultyLabel(question['difficulty'])}

''';
        }).join('\n')}

## خطة المراجعة المقترحة:

1. اليوم: راجع الشرح أعلاه بتركيز
2. غداً: حل أسئلة مشابهة من الكتاب
3. بعد يومين: اختبر نفسك مرة أخرى

## نصائح:
💡 لا تحفظ فقط، افهم المفاهيم
💡 حل أمثلة متنوعة
💡 اطلب المساعدة إذا لم تفهم

---
تم إنشاء هذا الشرح بناءً على نتيجة اختبارك
    ''';

    isGenerating.value = false;
    showExplanation.value = true;
  }

  String _getSkillLabel(String skill) {
    switch (skill) {
      case 'remember':
        return 'التذكر';
      case 'understand':
        return 'الفهم';
      case 'apply':
        return 'التطبيق';
      case 'analyze':
        return 'التحليل';
      default:
        return skill;
    }
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'سهل';
      case 'medium':
        return 'متوسط';
      case 'hard':
        return 'صعب';
      default:
        return difficulty;
    }
  }
}
