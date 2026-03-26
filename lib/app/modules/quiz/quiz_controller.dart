import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/modules/result/result_controller.dart';
import 'package:quiz_master_app/app/routes/app_routes.dart';

import '../../core/utils/helpers.dart';
import '../../data/models/question_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/result_model.dart';
import '../../data/repositories/assigned_exam_repository.dart';
import '../../data/repositories/practice_quiz_repository.dart';

class QuizController extends GetxController {
  final PracticeQuizRepository _practiceRepo =
      Get.find<PracticeQuizRepository>();

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

    final questions = quiz.value!.questions;
    int correctAnswers = 0;
    int wrongAnswers = 0;
    final answersList = <Map<String, dynamic>>[];

    // ── تشخيص: طباعة أول سؤال لمعرفة شكل البيانات ───────────────────────
    if (questions.isNotEmpty) {
      debugPrint(
        '🔍 First Q id="${questions.first.id}" (${questions.first.id.runtimeType})',
      );
      debugPrint('🔍 First Q correctAnswer="${questions.first.correctAnswer}"');
      debugPrint('🔍 First Q skill="${questions.first.skill}"');
    }

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final selected = answers[i];

      // ✅ إصلاح 1: تحويل id بأمان مع fallback لاستخراج الأرقام فقط
      int? qId = int.tryParse(q.id);
      if (qId == null) {
        final numericOnly = q.id.replaceAll(RegExp(r'[^0-9]'), '');
        qId = int.tryParse(numericOnly);
        if (qId != null) {
          debugPrint('⚠️ Q[$i] id converted from "${q.id}" → $qId');
        }
      }

      // ✅ إصلاح 2: حساب isCorrect
      final isCorrect = selected != null && selected == q.correctAnswer;

      if (selected != null) {
        if (isCorrect) {
          correctAnswers++;
        } else {
          wrongAnswers++;
        }
      }

      // ✅ إصلاح 3: تسجيل كل سؤال للتشخيص
      debugPrint(
        'Q[$i] qId=$qId | selected="$selected" | correct="${q.correctAnswer}" | isCorrect=$isCorrect | skill="${q.skill}"',
      );

      // ✅ إصلاح 4: أضف فقط الأسئلة التي نعرف id-ها
      if (qId != null) {
        answersList.add({
          'question_id': qId,
          'selected_answer': selected,
          'is_correct': isCorrect,
        });
      } else {
        debugPrint('❌ Q[$i] تجاهل — id غير صالح: "${q.id}"');
      }
    }

    debugPrint(
      '📊 answersList: ${answersList.length}/${questions.length} سؤال',
    );

    final unanswered = questions.length - answers.length;
    final timeTaken = (quiz.value!.timeLimit ?? 600) - timeRemaining.value;

    // ── حفظ حسب نوع الاختبار ─────────────────────────────────────────────
    if (quiz.value!.isAssignedExam) {
      // اختبار رسمي من المعلم → exam_results
      if (quiz.value!.assignmentId != null) {
        try {
          final repo = Get.find<AssignedExamRepository>();
          await repo.saveExamResult(
            assignmentId: quiz.value!.assignmentId!,
            examId: int.parse(quiz.value!.id),
            score: correctAnswers,
            totalQuestions: questions.length,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            timeTakenSeconds: timeTaken,
            answers: answersList,
          );
          debugPrint('✅ exam_result saved');
        } catch (e) {
          debugPrint('❌ saveExamResult error: $e');
        }
      }
    } else {
      // ✅ إصلاح 5: تدريب ذاتي → practice_quiz_attempts مع تحقق مفصّل
      final subjectId = int.tryParse(quiz.value!.subjectId);
      final chapterId = int.tryParse(quiz.value!.chapterId);

      debugPrint(
        '📦 subjectId=$subjectId | chapterId=$chapterId | answers=${answersList.length}',
      );

      if (subjectId == null) {
        debugPrint('❌ subjectId غير صالح: "${quiz.value!.subjectId}"');
      } else if (chapterId == null || chapterId == 0) {
        debugPrint('❌ chapterId غير صالح: "${quiz.value!.chapterId}"');
      } else if (answersList.isEmpty) {
        debugPrint('❌ answersList فارغة — لن تُحفظ المهارات في قاعدة البيانات');
      } else {
        try {
          await _practiceRepo.saveAttempt(
            subjectId: subjectId,
            chapterId: chapterId,
            score: correctAnswers,
            totalQuestions: questions.length,
            correctAnswers: correctAnswers,
            wrongAnswers: wrongAnswers,
            unanswered: unanswered,
            timeTakenSeconds: timeTaken,
            quizOptions: {'difficulty': 'mixed'},
            answers: answersList, // ✅ الإجابات مع question_id الصحيح
          );
          debugPrint(
            '✅ practice_attempt saved — ${answersList.length} answers',
          );
        } catch (e) {
          debugPrint('❌ saveAttempt error: $e');
        }
      }
    }

    // ── حساب masteryBySkill للـ ResultScreen ─────────────────────────────
    final masteryBySkill = <String, double>{};
    final skillQuestions = <String, List<int>>{};
    final skillCorrect = <String, int>{};

    for (int i = 0; i < questions.length; i++) {
      final skill = questions[i].skill;
      // ✅ إصلاح 6: تجاهل المهارات الفارغة أو unknown
      if (skill.isEmpty || skill == 'unknown') continue;

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

    debugPrint('🧠 masteryBySkill: $masteryBySkill');

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

    Get.delete<ResultController>();
    Get.offNamed(
      AppRoutes.RESULT,
      arguments: {'result': result, 'quiz': quiz.value, 'answers': answers},
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
