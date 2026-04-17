import 'package:flutter/material.dart' show Widget;
import 'package:get/get.dart';
import 'package:quiz_master_app/ai_services/ai_services.dart';
import 'package:quiz_master_app/ai_services/question_generator_enhanced.dart';
import 'package:quiz_master_app/ai_services/screens/ai_quiz_setup/ai_quiz_setup_screen.dart';
import '../home/home_view.dart';
import '../quiz_setup/quiz_setup_view.dart';
import '../summaries/summaries_view.dart';
import '../analytics/analytics_view.dart';
import '../profile/profile_view.dart';

class MainNavigationController extends GetxController {
  final selectedIndex = 2.obs;

  // Dummy instances for demonstration; replace with actual implementations
  final curriculumManager = CurriculumManager();
  final questionGenerator = EnhancedQuestionGenerator();
List<Widget> get screens => [
  const SummariesView(),
  AiQuizSetupScreen(
    curriculumManager: curriculumManager,
    questionGenerator: questionGenerator,
  ),
  const HomeView(),
  const AnalyticsView(),
  const ProfileView(),
];
  // final screens = [
  //   const SummariesView(),
  //   AiQuizSetupScreen(
  //     curriculumManager: curriculumManager,
  //     questionGenerator: questionGenerator,
  //   ),
  //   //const QuizSetupView(),
  //   const HomeView(),
  //   const AnalyticsView(),
  //   const ProfileView(),
  // ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
