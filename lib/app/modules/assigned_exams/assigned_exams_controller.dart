import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/quiz_model.dart';
import '../../data/repositories/assigned_exam_repository.dart';
import '../../routes/app_routes.dart';

class AssignedExamsController extends GetxController {
  final AssignedExamRepository _repo = Get.find<AssignedExamRepository>();

  final exams = <AssignedExamItem>[].obs;
  final isLoading = false.obs;
  final isLoadingExam = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadExams();
  }

  Future<void> loadExams() async {
    isLoading.value = true;
    try {
      exams.value = await _repo.getAssignedExams();
    } catch (e) {
      debugPrint('loadExams error: $e');
      Get.snackbar('خطأ', 'فشل تحميل الاختبارات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startExam(AssignedExamItem item) async {
    isLoadingExam.value = true;
    try {
      final quiz = await _repo.loadExamAsQuiz(item);

      if (quiz.questions.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'هذا الاختبار لا يحتوي على أسئلة بعد',
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
        );
        return;
      }

      Get.toNamed(AppRoutes.QUIZ, arguments: quiz);
    } catch (e) {
      debugPrint('startExam error: $e');
      Get.snackbar('خطأ', 'فشل تحميل الاختبار: $e');
    } finally {
      isLoadingExam.value = false;
    }
  }
}
