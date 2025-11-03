import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/modules/result/result_view.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/result_model.dart';
// import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';

class QuizController extends GetxController {
  final quiz = Rxn<QuizModel>();
  final currentQuestionIndex = 0.obs;
  final answers = <int, String>{}.obs;
  final timeRemaining = 0.obs;
  final isSubmitting = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    quiz.value = Get.arguments as QuizModel;
    timeRemaining.value = quiz.value!.timeLimit ?? 600;
    _startTimer();
  }

  QuestionModel get currentQuestion =>
      quiz.value!.questions[currentQuestionIndex.value];

  bool get isLastQuestion =>
      currentQuestionIndex.value == quiz.value!.questions.length - 1;

  bool get isFirstQuestion => currentQuestionIndex.value == 0;

  double get progress =>
      (currentQuestionIndex.value + 1) / quiz.value!.questions.length;

  int get answeredCount => answers.length;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        _timer?.cancel();
        Helpers.showWarningSnackbar('انتهى الوقت! سيتم إرسال الاختبار');
        submitQuiz();
      }
    });
  }

  void selectAnswer(String answer) {
    answers[currentQuestionIndex.value] = answer;
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (!isFirstQuestion) {
      currentQuestionIndex.value--;
    }
  }

  void goToQuestion(int index) {
    currentQuestionIndex.value = index;
  }

  Future<bool> onWillPop() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text(
          'هل تريد الخروج من الاختبار؟ سيتم فقد جميع الإجابات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('خروج'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> showSubmitDialog() async {
    final unanswered = quiz.value!.questions.length - answers.length;

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('إنهاء الاختبار'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عدد الأسئلة المجابة: ${answers.length}'),
            if (unanswered > 0)
              Text(
                'عدد الأسئلة غير المجابة: $unanswered',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            const Text('هل تريد إنهاء الاختبار وإرسال الإجابات؟'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('إنهاء'),
          ),
        ],
      ),
    );

    if (result == true) {
      await submitQuiz();
    }
  }

  Future<void> submitQuiz() async {
    _timer?.cancel();
    isSubmitting.value = true;

    await Future.delayed(const Duration(seconds: 1));

    // Calculate results
    int correctAnswers = 0;
    int wrongAnswers = 0;
    final questions = quiz.value!.questions;
    for (int i = 0; i < questions.length; i++) {
      if (answers.containsKey(i)) {
        if (answers[i] == questions[i].correctAnswer) {
          correctAnswers++;
        } else {
          wrongAnswers++;
        }
      }
    }

    final unanswered = questions.length - answers.length;
    final timeTaken = (quiz.value!.timeLimit ?? 600) - timeRemaining.value;

    // Calculate mastery by skill
    final masteryBySkill = <String, double>{};
    final skillQuestions = <String, List<int>>{};
    final skillCorrect = <String, int>{};

    for (int i = 0; i < questions.length; i++) {
      final skill = questions[i].skill;
      skillQuestions[skill] = (skillQuestions[skill] ?? [])..add(i);

      if (answers.containsKey(i) && answers[i] == questions[i].correctAnswer) {
        skillCorrect[skill] = (skillCorrect[skill] ?? 0) + 1;
      }
    }

    for (final skill in skillQuestions.keys) {
      final total = skillQuestions[skill]!.length;
      final correct = skillCorrect[skill] ?? 0;
      masteryBySkill[skill] = (correct / total) * 100;
    }

    final result = ResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      quizId: quiz.value!.id,
      score: correctAnswers,
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      unanswered: unanswered,
      timeTaken: timeTaken,
      completedAt: DateTime.now(),
      masteryBySkill: masteryBySkill,
    );

    isSubmitting.value = false;

    Get.off(
      () => const ResultView(),
      arguments: {'result': result, 'quiz': quiz.value, 'answers': answers},
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
