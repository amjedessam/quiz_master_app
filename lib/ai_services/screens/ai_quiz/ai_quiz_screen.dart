import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../models.dart';
import '../../question_generator_enhanced.dart';
import '../question_widget.dart';
import 'ai_quiz_controller.dart';

class AiQuizScreen extends StatefulWidget {
  final String stageId;
  final String subjectId;
  final String semesterId;
  final String unitId;
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;
  final int questionCount;
  final String difficulty;

  const AiQuizScreen({
    Key? key,
    required this.stageId,
    required this.semesterId,
    required this.subjectId,
    required this.unitId,
    required this.curriculumManager,
    required this.questionGenerator,
    this.questionCount = 10,
    this.difficulty = 'easy',
  }) : super(key: key);

  @override
  State<AiQuizScreen> createState() => _AiQuizScreenState();
}

class _AiQuizScreenState extends State<AiQuizScreen> {
  late final AiQuizController _controller;
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'ai_quiz_${DateTime.now().microsecondsSinceEpoch}';
    _controller = Get.put(
      AiQuizController(
        stageId: widget.stageId,
        semesterId: widget.semesterId,
        subjectId: widget.subjectId,
        unitId: widget.unitId,
        curriculumManager: widget.curriculumManager,
        questionGenerator: widget.questionGenerator,
        questionCount: widget.questionCount,
        difficulty: widget.difficulty,
      ),
      tag: _controllerTag,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiQuizController>(tag: _controllerTag)) {
      Get.delete<AiQuizController>(tag: _controllerTag);
    }
    super.dispose();
  }

  AiQuizController get controller => Get.find<AiQuizController>(tag: _controllerTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curriculumManager.getStage(widget.stageId)?.name ?? 'اختبار AI'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          
          print(controller.errorMessage.value);
          return _buildErrorState();
        }
        return _buildQuizBody();
      }),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(controller.errorMessage.value ?? '' , textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.loadAgain,
              child: const Text('حاول مرة أخرى'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizBody() {
    return Column(
      children: [
        LinearProgressIndicator(value: controller.questions.isEmpty ? 0 : (controller.currentPage.value + 1) / controller.questions.length, minHeight: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('السؤال ${controller.currentPage.value + 1} من ${controller.questions.length}'),
              Text('${Duration(seconds: controller.timeRemaining.value).inMinutes}:${(controller.timeRemaining.value % 60).toString().padLeft(2, '0')}'),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.questions.length,
            onPageChanged: controller.setCurrentPage,
            itemBuilder: (context, index) {
              return QuestionDisplay(
                question: controller.questions[index],
                questionNumber: index + 1,
                totalQuestions: controller.questions.length,
                onAnswered: (answer) => controller.answerQuestion(index, answer),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.currentPage.value > 0 ? () {
                        controller.pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } : null,
                      child: const Text('السابق'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.currentPage.value < controller.questions.length - 1
                          ? () {
                              controller.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                            }
                          : null,
                      child: const Text('التالي'),
                    ),
                  ),
                ],
              ),
              if (controller.currentPage.value == controller.questions.length - 1)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.submitQuiz,
                      icon: const Icon(Icons.check),
                      label: const Text('إنهاء الاختبار'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
