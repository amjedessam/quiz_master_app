import 'package:get/get.dart';
import '../../data/models/result_model.dart';
import '../../data/models/quiz_model.dart';
import '../../routes/app_routes.dart';

class ResultController extends GetxController {
  final result = Rxn<ResultModel>();
  final quiz = Rxn<QuizModel>();
  final answers = <int, String>{}.obs;
  final showAnimation = true.obs;
  final showExplanationSuggestion = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    result.value = args['result'];
    quiz.value = args['quiz'];
    answers.value = RxMap<int, String>.from(args['answers']);

    _animateScore();
    _checkIfNeedsExplanation();
  }

  void _animateScore() async {
    await Future.delayed(const Duration(milliseconds: 500));
    showAnimation.value = false;
  }

  void _checkIfNeedsExplanation() {
    if (result.value!.percentage < 60) {
      showExplanationSuggestion.value = true;
    }
  }

  void reviewAnswers() {
    Get.toNamed(
      AppRoutes.REVIEW,
      arguments: {
        'quiz': quiz.value,
        'answers': answers,
        'result': result.value,
      },
    );
  }

  void retakeQuiz() {
    Get.back();
    Get.back();
  }

  void goHome() {
    Get.offAllNamed(AppRoutes.HOME);
  }

  void requestExplanation() {
    final wrongQuestions = <Map<String, dynamic>>[];
    final weakTopics = <String>{};

    for (int i = 0; i < quiz.value!.questions.length; i++) {
      final question = quiz.value!.questions[i];
      final userAnswer = answers[i];

      if (userAnswer == null || userAnswer != question.correctAnswer) {
        wrongQuestions.add({
          'content': question.content,
          'userAnswer': userAnswer,
          'correctAnswer': question.correctAnswer,
          'explanation': question.explanation,
          'skill': question.skill,
          'difficulty': question.difficulty,
          'referencePage': question.referencePage,
        });

        weakTopics.add(
          '${quiz.value!.chapterName} - ${_getSkillLabel(question.skill)}',
        );
      }
    }

    Get.toNamed(
      AppRoutes.EXPLANATION,
      arguments: {
        'mode': 'auto',
        'weakTopics': weakTopics.toList(),
        'wrongQuestions': wrongQuestions,
      },
    );
  }

  void dismissExplanationSuggestion() {
    showExplanationSuggestion.value = false;
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
}
