import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import '../../models.dart';
import '../ai_quiz_result/ai_quiz_result_screen.dart';

class AiQuizController extends GetxController {
  final String stageId;
  final String subjectId;
  final String semesterId;
  final String unitId;
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;
  final int questionCount;
  final String difficulty;

  final questions = <dynamic>[].obs;
  final answers = <String>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final currentPage = 0.obs;
  final timeRemaining = 0.obs;
  late DateTime _startTime;
  final pageController = PageController();
  Timer? _timer;

  AiQuizController({
    required this.stageId,
    required this.subjectId,
    required this.semesterId,
    required this.unitId,
    CurriculumManager? curriculumManager,
    EnhancedQuestionGenerator? questionGenerator,
    this.questionCount = 10,
    this.difficulty = 'easy',
  })  : curriculumManager = curriculumManager ?? CurriculumManager(),
        questionGenerator = questionGenerator ?? EnhancedQuestionGenerator();

  @override
  void onInit() {
    super.onInit();
    _startTime = DateTime.now();
    timeRemaining.value = questionCount * 60;
    _loadQuestions();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  Future<void> _loadQuestions() async {
    try {
      final unit = curriculumManager
          .getUnitsForSemester(stageId, subjectId, semesterId)
          ?.firstWhere((u) => u.id == unitId);

      if (unit == null) {
        errorMessage.value = 'لم يتم العثور على الوحدة المختارة';
        isLoading.value = false;
        return;
      }

      final context = curriculumManager.generateQuizContext(
        stageId,
        subjectId,
        semesterId,
        unitId,
      );

      final variedQuestions = await questionGenerator.generateVariedQuestions(
        unit.name,
        '$context مستوى الصعوبة: $difficulty',
        questionCount,
      );

      final allQuestions = <dynamic>[];
      allQuestions.addAll(variedQuestions['multipleChoice'] as List? ?? []);
      allQuestions.addAll(variedQuestions['trueFalse'] as List? ?? []);
      allQuestions.addAll(variedQuestions['fillInBlanks'] as List? ?? []);
      allQuestions.addAll(variedQuestions['shortAnswer'] as List? ?? []);

      if (allQuestions.isEmpty) {
        errorMessage.value = 'لم يتم توليد أسئلة. حاول تغيير العدد أو الموضع.';
        isLoading.value = false;
        return;
      }

      questions.value = allQuestions;
      answers.assignAll(List.filled(allQuestions.length, ''));
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل الأسئلة: $e';
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        timer.cancel();
        submitQuiz();
      }
    });
  }

  void setCurrentPage(int page) {
    currentPage.value = page;
  }

  void answerQuestion(int index, String answer) {
    if (index < 0 || index >= answers.length) return;
    answers[index] = answer;
  }

  bool _isAnswerCorrect(dynamic question, String answer) {
    if (question is Question) {
      return question.correctAnswer.trim() == answer.trim();
    }
    if (question is TrueFalseQuestion) {
      return question.correctAnswer.toString() == answer;
    }
    if (question is FillInTheBlanksQuestion) {
      return question.correctAnswers
          .map((e) => e.toLowerCase().trim())
          .contains(answer.toLowerCase().trim());
    }
    if (question is MultiSelectQuestion) {
      final selected = answer
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return question.correctAnswers.every((correct) => selected.contains(correct));
    }
    if (question is ShortAnswerQuestion) {
      return question.acceptableAnswers.any(
        (correct) => answer.toLowerCase().contains(correct.toLowerCase()),
      );
    }
    return false;
  }

  void submitQuiz() {
    if (questions.isEmpty) return;
    _timer?.cancel();

    final results = <QuestionResult>[];
    int correctCount = 0;

    for (var index = 0; index < questions.length; index++) {
      final question = questions[index];
      final answer = answers[index];
      final isCorrect = _isAnswerCorrect(question, answer);
      if (isCorrect) correctCount++;
      results.add(QuestionResult(
        questionId: 'q_${index}_${question.hashCode}',
        userAnswer: answer,
        isCorrect: isCorrect,
        timeSpent: const Duration(seconds: 0),
      ));
    }

    final result = QuizResult(
      quizId: '${unitId}_${DateTime.now().millisecondsSinceEpoch}',
      studentId: 'student_ai',
      completedAt: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      timeTaken: DateTime.now().difference(_startTime),
      results: results,
    );

    Get.to(() => AiQuizResultScreen(
          quizResult: result,
          onBack: () {
            Get.back();
            Get.back();
          },
          onRetry: () {
            loadAgain();
          },
        ));
  }

  void loadAgain() {
    isLoading.value = true;
    errorMessage.value = null;
    answers.clear();
    questions.clear();
    currentPage.value = 0;
    timeRemaining.value = questionCount * 60;
    _startTime = DateTime.now();
    _loadQuestions();
    _startTimer();
  }
}
