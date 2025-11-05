import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../quiz/widgets/quiz_option_card.dart';
import 'review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الإجابات')),
      body: Obx(() {
        final questions = controller.quiz.value!.questions;

        return Column(
          children: [
            _buildFilterChips(),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = controller.answers[index];
                  final isCorrect = userAnswer == question.correctAnswer;
                  final isAnswered = userAnswer != null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isAnswered
                                      ? (isCorrect
                                            ? AppColors.success
                                            : AppColors.error)
                                      : AppColors.textSecondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isAnswered
                                          ? (isCorrect
                                                ? Icons.check_circle
                                                : Icons.cancel)
                                          : Icons.help_outline,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'س ${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (!isAnswered)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'لم يتم الإجابة',
                                    style: TextStyle(
                                      color: AppColors.warning,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            question.content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ...question.options.entries.map((entry) {
                            final isUserAnswer = userAnswer == entry.key;
                            final isCorrectAnswer =
                                entry.key == question.correctAnswer;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: QuizOptionCard(
                                option: entry.key,
                                text: entry.value,
                                isSelected: isUserAnswer,
                                isCorrect: isCorrectAnswer
                                    ? true
                                    : (isUserAnswer ? false : null),
                                onTap: () {},
                              ),
                            );
                          }).toList(),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.info.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: AppColors.info,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'الشرح:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.info,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  question.explanation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                if (question.referencePage != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'المرجع: ${question.referencePage}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                'all',
                'الكل (${controller.quiz.value!.questions.length})',
                Icons.list,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                'correct',
                'صحيحة (${controller.result.value!.correctAnswers})',
                Icons.check_circle,
                AppColors.success,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                'wrong',
                'خاطئة (${controller.result.value!.wrongAnswers})',
                Icons.cancel,
                AppColors.error,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                'unanswered',
                'غير مجابة (${controller.result.value!.unanswered})',
                Icons.help_outline,
                AppColors.warning,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String value,
    String label,
    IconData icon, [
    Color? color,
  ]) {
    final isSelected = controller.filterType.value == value;
    final chipColor = color ?? AppColors.primary;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? chipColor : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (_) => controller.changeFilter(value),
      backgroundColor: Colors.white,
      selectedColor: chipColor.withOpacity(0.2),
      checkmarkColor: chipColor,
      side: BorderSide(
        color: isSelected ? chipColor : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? chipColor : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
