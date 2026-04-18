import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import '../../models.dart';
import '../ai_quiz_result/ai_quiz_result_screen.dart';

class AiQuizController extends GetxController {
  final String stageId;
  final String semesterId;
  final String subjectId;
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
  final questionStartTimes = <DateTime>[].obs;
  final questionTimes = <Duration>[].obs;
  late DateTime _startTime;
  final pageController = PageController();
  Timer? _timer;

  AiQuizController({
    required this.stageId,
    required this.semesterId,
    required this.subjectId,
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
          .getUnits(stageId, semesterId, subjectId)
          ?.firstWhere((u) => u.id == unitId);

      if (unit == null) {
        errorMessage.value = 'لم يتم العثور على الوحدة المختارة';
        isLoading.value = false;
        return;
      }

      final context = curriculumManager.generateQuizContext(
        stageId,
        semesterId,
        subjectId,
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
      questionStartTimes.assignAll(List.filled(allQuestions.length, DateTime.now()));
      questionTimes.assignAll(List.filled(allQuestions.length, Duration.zero));
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
    if (page == currentPage.value) return;

    // Calculate time spent on previous question
    if (currentPage.value >= 0 && currentPage.value < questionTimes.length) {
      questionTimes[currentPage.value] = DateTime.now().difference(questionStartTimes[currentPage.value]);
    }

    // Set start time for new question
    if (page >= 0 && page < questionStartTimes.length) {
      questionStartTimes[page] = DateTime.now();
    }

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

  String _getCorrectAnswer(dynamic question) {
    if (question is Question) {
      return question.correctAnswer;
    }
    if (question is TrueFalseQuestion) {
      return question.correctAnswer.toString();
    }
    if (question is FillInTheBlanksQuestion) {
      return question.correctAnswers.join(', ');
    }
    if (question is MultiSelectQuestion) {
      return question.correctAnswers.join(', ');
    }
    if (question is ShortAnswerQuestion) {
      return question.acceptableAnswers.join(' أو ');
    }
    return '';
  }
String getExplanation(dynamic question) {
    if (question is Question) {
      return question.explanation;
    }
    if (question is TrueFalseQuestion) {
      return question.explanation;
    }
    if (question is FillInTheBlanksQuestion) {
      return question.explanation;
    }
    if (question is MultiSelectQuestion) {
      return question.explanation;
    }
    if (question is ShortAnswerQuestion) {
      return question.explanation;
    }
    return '';
  }
  void submitQuiz() {
    if (questions.isEmpty) return;
    _timer?.cancel();

    // Calculate time for the last question
    if (currentPage.value >= 0 && currentPage.value < questionTimes.length) {
      questionTimes[currentPage.value] = DateTime.now().difference(questionStartTimes[currentPage.value]);
    }

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
        correctAnswer: _getCorrectAnswer(question),
        explanation: getExplanation(question),
        isCorrect: isCorrect,
        timeSpent: questionTimes[index],
      ));
    }

    final result = QuizResult(
      quizId: '${unitId}_${DateTime.now().millisecondsSinceEpoch}',
      studentId: 'student_ai',
      completedAt: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      explanation:getExplanation(questions[currentPage.value]) ,
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
