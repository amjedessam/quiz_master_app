import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/helpers.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/services/supabase_service.dart';

class ExplanationController extends GetxController {
  final SubjectRepository _subjectRepo = Get.find<SubjectRepository>();
  final SupabaseService _supabase = Get.find<SupabaseService>();

  final mode = ''.obs;
  final subjects = <SubjectModel>[].obs;
  final chapters = <ChapterModel>[].obs;

  final selectedSubject = Rxn<SubjectModel>();
  final selectedChapter = Rxn<ChapterModel>();
  final topicController = TextEditingController();

  final isGenerating = false.obs;
  final explanation = ''.obs;
  final showExplanation = false.obs;

  // Used in auto mode (wrong questions from quiz result passed as args)
  final wrongQuestions = <Map<String, dynamic>>[].obs;
  final weakTopics = <String>[].obs;

  // Pre-seeded chapter_id when coming from Chapter Details / Analytics
  int? _preselectedChapterId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      mode.value = args['mode']?.toString() ?? 'manual';

      if (mode.value == 'direct') {
        // Content already prepared — just show it
        explanation.value = args['content']?.toString() ?? '';
        showExplanation.value = true;
      } else if (mode.value == 'auto') {
        // Coming from quiz result with wrong questions list
        wrongQuestions.value = List<Map<String, dynamic>>.from(
          args['wrongQuestions'] ?? [],
        );
        weakTopics.value = List<String>.from(args['weakTopics'] ?? []);
        _buildAutoExplanation();
      } else {
        // manual — may come pre-loaded with chapter_id from Chapter Details or Analytics
        _preselectedChapterId = args['chapter_id'] as int?;
        if (args['topic_hint'] != null) {
          topicController.text = args['topic_hint'].toString();
        }
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
    try {
      subjects.value = await _subjectRepo.getSubjectsWithStats();
    } catch (_) {
      subjects.value = [];
    }
  }

  void selectSubject(SubjectModel subject) {
    selectedSubject.value = subject;
    selectedChapter.value = null;
    _preselectedChapterId = null;
    final subjectId = int.tryParse(subject.id);
    if (subjectId != null) {
      _loadChapters(subjectId);
    }
  }

  Future<void> _loadChapters(int subjectId) async {
    try {
      chapters.value = await _subjectRepo.getChaptersWithProgress(subjectId);

      // Auto-select if a chapter was pre-selected (from chapter_details)
      if (_preselectedChapterId != null) {
        final pre = chapters.firstWhereOrNull(
          (c) => int.tryParse(c.id) == _preselectedChapterId,
        );
        if (pre != null) selectedChapter.value = pre;
      }
    } catch (_) {
      chapters.value = [];
    }
  }

  void selectChapter(ChapterModel chapter) {
    selectedChapter.value = chapter;
  }

  // ──────────────────────────────────────────────────────────────────
  // Manual mode: fetch real questions with explanations from DB
  // ──────────────────────────────────────────────────────────────────
  Future<void> requestManualExplanation() async {
    if (selectedSubject.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار المادة');
      return;
    }

    isGenerating.value = true;

    try {
      final chapterId = selectedChapter.value != null
          ? int.tryParse(selectedChapter.value!.id)
          : _preselectedChapterId;
      final subjectId = int.tryParse(selectedSubject.value!.id);

      final response = await _supabase.client.rpc(
        'get_questions_for_explanation',
        params: {
          'p_chapter_id': chapterId,
          'p_subject_id': subjectId,
          'p_limit': 20,
        },
      );

      if (response == null || (response is List && response.isEmpty)) {
        explanation.value =
            '# لا يوجد شرح متاح\n\nلم يتم إضافة شرح لأسئلة هذا الفصل بعد.\n'
            'يُرجى مراجعة معلمك أو التحقق لاحقاً.';
        showExplanation.value = true;
        return;
      }

      final list = response is List ? response : [response];
      final questions = list
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((q) => q['explanation']?.toString().isNotEmpty == true)
          .toList();

      if (questions.isEmpty) {
        explanation.value =
            '# لا يوجد شرح متاح\n\nلم يتم إضافة شرح لأسئلة هذا الفصل بعد.\n'
            'يُرجى مراجعة معلمك أو التحقق لاحقاً.';
        showExplanation.value = true;
        return;
      }

      explanation.value = _buildManualMarkdown(questions);
      showExplanation.value = true;
    } catch (_) {
      explanation.value =
          '# حدث خطأ\n\nتعذّر تحميل الشرح. تحقق من اتصالك وحاول مرة أخرى.';
      showExplanation.value = true;
    } finally {
      isGenerating.value = false;
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // Auto mode: wrong questions passed via args (from quiz result)
  // ──────────────────────────────────────────────────────────────────
  void _buildAutoExplanation() {
    isGenerating.value = true;

    if (wrongQuestions.isEmpty) {
      explanation.value = '# لا توجد أسئلة خاطئة\n\nأحسنت! لم تخطئ في أي سؤال.';
      showExplanation.value = true;
      isGenerating.value = false;
      return;
    }

    final topics = weakTopics.isNotEmpty
        ? weakTopics.join('، ')
        : 'المواضيع التي أخطأت فيها';

    final buffer = StringBuffer();
    buffer.writeln('# شرح نقاط الضعف في الاختبار\n');
    buffer.writeln('## المواضيع التي تحتاج مراجعة:\n$topics\n');
    buffer.writeln('## تحليل أخطائك:\n');
    buffer.writeln('لقد واجهت صعوبة في ${wrongQuestions.length} سؤال/أسئلة.\n');

    for (int i = 0; i < wrongQuestions.length; i++) {
      final q = wrongQuestions[i];
      buffer.writeln('---\n');
      buffer.writeln('### السؤال ${i + 1}:');
      buffer.writeln('${q['content'] ?? q['question_text'] ?? ''}\n');
      buffer.writeln(
        '❌ إجابتك: ${q['userAnswer'] ?? q['selected_answer'] ?? 'لم تجب'}',
      );
      buffer.writeln(
        '✅ الإجابة الصحيحة: ${q['correctAnswer'] ?? q['correct_answer'] ?? ''}\n',
      );

      final exp = q['explanation']?.toString() ?? '';
      if (exp.isNotEmpty) {
        buffer.writeln('#### الشرح:\n$exp\n');
      } else {
        buffer.writeln('#### الشرح:\nلا يوجد شرح مضاف لهذا السؤال بعد.\n');
      }

      if (q['reference_page'] != null) {
        buffer.writeln('📖 مرجع: ${q['reference_page']}');
      }
      if (q['skill'] != null) {
        buffer.writeln(
          '🧠 المهارة المقاسة: ${_skillLabel(q['skill'].toString())}',
        );
      }
      if (q['difficulty'] != null || q['difficulty_level'] != null) {
        buffer.writeln(
          '📊 مستوى الصعوبة: ${_difficultyLabel((q['difficulty'] ?? q['difficulty_level']).toString())}',
        );
      }
      buffer.writeln();
    }

    buffer.writeln('---\n');
    buffer.writeln('## خطة المراجعة المقترحة:\n');
    buffer.writeln('1. اليوم: راجع الشرح أعلاه بتركيز');
    buffer.writeln('2. غداً: حل أسئلة مشابهة من الكتاب');
    buffer.writeln('3. بعد يومين: اختبر نفسك مرة أخرى');

    explanation.value = buffer.toString();
    showExplanation.value = true;
    isGenerating.value = false;
  }

  // ──────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────
  String _buildManualMarkdown(List<Map<String, dynamic>> questions) {
    final chapterName =
        selectedChapter.value?.name ??
        (topicController.text.trim().isNotEmpty
            ? topicController.text.trim()
            : '');
    final subjectName = selectedSubject.value?.name ?? '';

    final buffer = StringBuffer();
    buffer.writeln('# شرح: $chapterName');
    buffer.writeln('## $subjectName\n');
    buffer.writeln('---\n');

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      buffer.writeln('### سؤال ${i + 1}:');
      buffer.writeln('${q['question_text'] ?? ''}\n');
      buffer.writeln('✅ الإجابة الصحيحة: ${q['correct_answer'] ?? ''}\n');
      buffer.writeln('#### الشرح:');
      buffer.writeln('${q['explanation']}\n');

      if (q['skill'] != null) {
        buffer.writeln('🧠 المهارة: ${_skillLabel(q['skill'].toString())}');
      }
      if (q['reference_page'] != null) {
        buffer.writeln('📖 المرجع: ${q['reference_page']}');
      }
      buffer.writeln('\n---\n');
    }

    return buffer.toString();
  }

  String _skillLabel(String skill) {
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

  String _difficultyLabel(String difficulty) {
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
