// import 'package:get/get.dart';
// import '../../data/models/subject_model.dart';
// import '../../data/models/chapter_model.dart';
// import '../../data/models/quiz_model.dart';
// // import '../../data/models/question_model.dart';
// import '../../data/services/mock_data_service.dart';
// import '../../routes/app_routes.dart';
// import '../../core/utils/helpers.dart';

// class QuizSetupController extends GetxController {
//   final subject = Rxn<SubjectModel>();
//   final chapter = Rxn<ChapterModel>();

//   final questionCount = 10.obs;
//   final selectedDifficulty = 'mixed'.obs;
//   final selectedTypes = <String>[].obs;
//   final isGenerating = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     final args = Get.arguments as Map<String, dynamic>;
//     subject.value = args['subject'];
//     chapter.value = args['chapter'];

//     // Select all types by default
//     selectedTypes.value = ['multiple_choice', 'true_false'];
//   }

//   void updateQuestionCount(double value) {
//     questionCount.value = value.toInt();
//   }

//   void selectDifficulty(String difficulty) {
//     selectedDifficulty.value = difficulty;
//   }

//   void toggleQuestionType(String type) {
//     if (selectedTypes.contains(type)) {
//       if (selectedTypes.length > 1) {
//         selectedTypes.remove(type);
//       } else {
//         Helpers.showWarningSnackbar('يجب اختيار نوع واحد على الأقل');
//       }
//     } else {
//       selectedTypes.add(type);
//     }
//   }

//   Future<void> generateQuiz() async {
//     isGenerating.value = true;

//     await Future.delayed(const Duration(seconds: 2));

//     // Generate mock quiz
//     final questions = MockDataService.getMockQuestions(
//       count: questionCount.value,
//     );

//     final quiz = QuizModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       subjectId: subject.value!.id,
//       subjectName: subject.value!.name,
//       chapterId: chapter.value!.id,
//       chapterName: chapter.value!.name,
//       questions: questions,
//       createdAt: DateTime.now(),
//       timeLimit: questionCount.value * 60, // 1 minute per question
//     );

//     isGenerating.value = false;

//     Get.toNamed(AppRoutes.QUIZ, arguments: quiz);
//   }
// }

import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/quiz_model.dart';
// import '../../data/models/question_model.dart';
import '../../data/services/mock_data_service.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/helpers.dart';

class QuizSetupController extends GetxController {
  final subjects = <SubjectModel>[].obs;
  final chapters = <ChapterModel>[].obs;

  final selectedSubject = Rxn<SubjectModel>();
  final selectedChapter = Rxn<ChapterModel>();

  final questionCount = 10.obs;
  final selectedDifficulty = 'mixed'.obs;
  final selectedTypes = <String>[].obs;
  final isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();

    // تحميل المواد
    _loadSubjects();

    // التحقق من وجود arguments (قادم من subject details)
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      selectedSubject.value = args['subject'] as SubjectModel?;
      selectedChapter.value = args['chapter'] as ChapterModel?;

      if (selectedSubject.value != null) {
        _loadChapters(selectedSubject.value!.id);
      }
    }

    // اختيار جميع الأنواع افتراضياً
    selectedTypes.value = ['multiple_choice', 'true_false'];
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
    // التحقق من اختيار المادة
    if (selectedSubject.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار المادة');
      return;
    }

    // التحقق من اختيار الفصل
    if (selectedChapter.value == null) {
      Helpers.showErrorSnackbar('الرجاء اختيار الفصل');
      return;
    }

    isGenerating.value = true;

    await Future.delayed(const Duration(seconds: 2));

    // توليد الأسئلة
    final questions = MockDataService.getMockQuestions(
      count: questionCount.value,
    );

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

    isGenerating.value = false;

    Get.toNamed(AppRoutes.QUIZ, arguments: quiz);
  }
}
