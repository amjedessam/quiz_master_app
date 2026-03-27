import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/helpers.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../routes/app_routes.dart';

class QuizSetupController extends GetxController {
  final SubjectRepository _subjectRepo = Get.find<SubjectRepository>();
  final QuestionRepository _questionRepo = Get.find<QuestionRepository>();

  final subjects = <SubjectModel>[].obs;
  final chapters = <ChapterModel>[].obs;
  final scrollController = ScrollController();

  final selectedSubject = Rxn<SubjectModel>();
  final selectedChapter = Rxn<ChapterModel>();

  final questionCount = 10.obs;
  final selectedDifficulty = 'mixed'.obs;
  final selectedTypes = <String>[].obs;
  final isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();

    _loadSubjects();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      selectedSubject.value = args['subject'] as SubjectModel?;
      selectedChapter.value = args['chapter'] as ChapterModel?;

      if (selectedSubject.value != null) {
        final subjectId = int.tryParse(selectedSubject.value!.id);
        if (subjectId != null) {
          _loadChapters(subjectId);
        }
      }
    }

    selectedTypes.value = ['multiple_choice', 'true_false'];
  }

  Future<void> _loadSubjects() async {
    try {
      subjects.value = await _subjectRepo.getSubjectsWithStats();
    } catch (e) {
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
    } catch (e) {
      chapters.value = [];
    }
  }

  void selectChapter(ChapterModel chapter) {
    selectedChapter.value = chapter;
    _scrollToOptions();
  }

  void _scrollToOptions() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void resetSelection() {
    selectedSubject.value = null;
    selectedChapter.value = null;
    chapters.clear();
  }

  void updateQuestionCount(double value) {
    questionCount.value = value.toInt();
  }

  void selectDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
  }

  void toggleQuestionType(String type) {
    if (selectedTypes.contains(type)) {
      if (selectedTypes.length > 1) {
        selectedTypes.remove(type);
      } else {
        Helpers.showWarningSnackbar('يجب اختيار نوع واحد على الأقل');
      }
    } else {
      selectedTypes.add(type);
    }
  }

  Future<void> generateQuiz() async {
    if (selectedSubject.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار المادة');
      return;
    }

    if (selectedChapter.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار الفصل');
      return;
    }

    isGenerating.value = true;

    try {
      final chapterId = int.tryParse(selectedChapter.value!.id);
      if (chapterId == null) {
        Helpers.showErrorSnackbar('فصل غير صالح');
        return;
      }

      final difficulty = selectedDifficulty.value == 'mixed'
          ? null
          : selectedDifficulty.value;

      final questions = await _questionRepo.getQuestionsForQuiz(
        chapterId: chapterId,
        count: questionCount.value,
        difficulty: difficulty,
        types: selectedTypes.isNotEmpty ? selectedTypes.toList() : null,
      );

      if (questions.isEmpty) {
        Helpers.showErrorSnackbar(
          'لا توجد أسئلة متاحة لهذا الفصل. تأكد من إضافة أسئلة من لوحة التحكم.',
        );
        return;
      }

      final quiz = QuizModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subjectId: selectedSubject.value!.id,
        subjectName: selectedSubject.value!.name,
        chapterId: selectedChapter.value!.id,
        chapterName: selectedChapter.value!.name,
        questions: questions,
        createdAt: DateTime.now(),
        timeLimit: questionCount.value * 60,
      );

      Get.toNamed(AppRoutes.QUIZ, arguments: quiz);
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء تحميل الأسئلة');
    } finally {
      isGenerating.value = false;
    }
  }
}
