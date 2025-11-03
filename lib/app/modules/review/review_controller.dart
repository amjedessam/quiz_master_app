import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/result_model.dart';
import '../../data/models/question_model.dart';

class ReviewController extends GetxController {
  final quiz = Rxn<QuizModel>();
  final answers = <int, String>{}.obs;
  final result = Rxn<ResultModel>();
  final currentIndex = 0.obs;
  final filterType = 'all'.obs; // all, correct, wrong, unanswered

  List<QuestionModel> get filteredQuestions {
    final questions = quiz.value!.questions;

    switch (filterType.value) {
      case 'correct':
        return questions
            .asMap()
            .entries
            .where(
              (entry) =>
                  answers.containsKey(entry.key) &&
                  answers[entry.key] == entry.value.correctAnswer,
            )
            .map((e) => e.value)
            .toList();
      case 'wrong':
        return questions
            .asMap()
            .entries
            .where(
              (entry) =>
                  answers.containsKey(entry.key) &&
                  answers[entry.key] != entry.value.correctAnswer,
            )
            .map((e) => e.value)
            .toList();
      case 'unanswered':
        return questions
            .asMap()
            .entries
            .where((entry) => !answers.containsKey(entry.key))
            .map((e) => e.value)
            .toList();
      default:
        return questions;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    quiz.value = args['quiz'];
    answers.value = RxMap<int, String>.from(args['answers']);
    result.value = args['result'];
  }

  void changeFilter(String filter) {
    filterType.value = filter;
    currentIndex.value = 0;
  }

  void goToQuestion(int index) {
    currentIndex.value = index;
  }
}
