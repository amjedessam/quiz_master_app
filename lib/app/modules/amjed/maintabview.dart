import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../quiz_setup/quiz_setup_view.dart';
import '../quiz_setup/quiz_setup_controller.dart';

class MainTabView extends StatelessWidget {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<QuizSetupController>()) {
      Get.put(QuizSetupController());
    }

    return const Scaffold(
      body: SafeArea(child: QuizSetupView(showHistory: false)),
    );
  }
}
