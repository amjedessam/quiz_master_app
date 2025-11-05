import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'quiz_controller.dart';
import 'widgets/quiz_option_card.dart';
import 'widgets/question_navigator.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(controller.quiz.value?.subjectName ?? '')),
          actions: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: controller.timeRemaining.value < 60
                          ? Colors.red.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 18,
                          color: controller.timeRemaining.value < 60
                              ? Colors.red
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDuration(
                            controller.timeRemaining.value,
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: controller.timeRemaining.value < 60
                                ? Colors.red
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Obx(
              () => LinearProgressIndicator(
                value: controller.progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'السؤال ${controller.currentQuestionIndex.value + 1} من ${controller.quiz.value!.questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Get.bottomSheet(
                          QuestionNavigator(controller: controller),
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.grid_view, size: 18),
                      label: Text('${controller.answeredCount} مجابة'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final question = controller.currentQuestion;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            question.content,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      ...question.options.entries.map((entry) {
                        final isSelected =
                            controller.answers[controller
                                .currentQuestionIndex
                                .value] ==
                            entry.key;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: QuizOptionCard(
                            option: entry.key,
                            text: entry.value,
                            isSelected: isSelected,
                            onTap: () => controller.selectAnswer(entry.key),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
            ),

            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Obx(
              () => !controller.isFirstQuestion
                  ? Expanded(
                      child: OutlinedButton(
                        onPressed: controller.previousQuestion,
                        child: const Text('السابق'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            Obx(
              () => !controller.isFirstQuestion
                  ? const SizedBox(width: 12)
                  : const SizedBox.shrink(),
            ),

            Expanded(
              flex: controller.isFirstQuestion ? 1 : 2,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () {
                    if (controller.isLastQuestion) {
                      controller.showSubmitDialog();
                    } else {
                      controller.nextQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    controller.isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
