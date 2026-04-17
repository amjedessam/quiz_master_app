import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../models.dart';
import 'ai_quiz_result_controller.dart';

class AiQuizResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiQuizResultController>(() {
      final args = Get.arguments as Map<String, dynamic>?;
      final controller = AiQuizResultController();
      if (args != null && args['quizResult'] is QuizResult) {
        controller.initialize(
          quizResult: args['quizResult'] as QuizResult,
          onRetry: args['onRetry'] as VoidCallback?,
          onBack: args['onBack'] as VoidCallback?,
        );
      }
      return controller;
    });
  }
}
