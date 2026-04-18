import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import 'ai_quiz_controller.dart';

class AiQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiQuizController>(() {
      final args = Get.arguments as Map<String, dynamic>?;
      return AiQuizController(
        stageId: args?['stageId'] as String? ?? '',
        semesterId: args?['semesterId'] as String? ?? '',
        subjectId: args?['subjectId'] as String? ?? '',
        unitId: args?['unitId'] as String? ?? '',
        curriculumManager: args?['curriculumManager'] as CurriculumManager?,
        questionGenerator: args?['questionGenerator'] as EnhancedQuestionGenerator?,
        questionCount: args?['questionCount'] as int? ?? 10,
        difficulty: args?['difficulty'] as String? ?? 'easy',
      );
    });
  }
}
