import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../models.dart';

class AiQuizResultController extends GetxController {
  late final QuizResult quizResult;
  VoidCallback? onRetry;
  VoidCallback? onBack;

  AiQuizResultController();

  void initialize({
    required QuizResult quizResult,
    VoidCallback? onRetry,
    VoidCallback? onBack,
  }) {
    this.quizResult = quizResult;
    this.onRetry = onRetry;
    this.onBack = onBack;
  }
}
