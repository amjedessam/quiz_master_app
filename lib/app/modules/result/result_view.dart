// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quiz_master_app/app/data/models/result_model.dart';
// import '../../core/theme/app_colors.dart';
// import '../../core/utils/helpers.dart';
// import 'result_controller.dart';

// class ResultView extends GetView<ResultController> {
//   const ResultView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Close Button
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: controller.goHome,
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(24),
//                 child: Obx(() {
//                   final result = controller.result.value!;
//                   return Column(
//                     children: [
//                       // Congratulations Message
//                       _buildCongratsMessage(result.percentage),

//                       const SizedBox(height: 32),

//                       // Animated Score Circle
//                       _buildScoreCircle(result),

//                       const SizedBox(height: 32),

//                       // Performance Breakdown
//                       _buildPerformanceBreakdown(result),

//                       const SizedBox(height: 24),

//                       // Mastery Progress
//                       _buildMasteryProgress(result),

//                       const SizedBox(height: 32),

//                       // Action Buttons
//                       _buildActionButtons(),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCongratsMessage(double percentage) {
//     String message = '';
//     String emoji = '';
//     Color color = AppColors.primary;

//     if (percentage >= 90) {
//       message = 'ممتاز! 🎉';
//       emoji = '🏆';
//       color = AppColors.success;
//     } else if (percentage >= 70) {
//       message = 'أحسنت! 👍';
//       emoji = '⭐';
//       color = AppColors.primary;
//     } else if (percentage >= 50) {
//       message = 'جيد، يمكنك التحسن 💪';
//       emoji = '📈';
//       color = AppColors.warning;
//     } else {
//       message = 'تحتاج للمزيد من المراجعة 📚';
//       emoji = '💡';
//       color = AppColors.error;
//     }

//     return Column(
//       children: [
//         Text(emoji, style: const TextStyle(fontSize: 60)),
//         const SizedBox(height: 16),
//         Text(
//           message,
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildScoreCircle(ResultModel result) {
//     final percentage = result.percentage;

//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 1500),
//       tween: Tween(begin: 0.0, end: percentage / 100),
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return SizedBox(
//           width: 200,
//           height: 200,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // Background Circle
//               SizedBox(
//                 width: 200,
//                 height: 200,
//                 child: CircularProgressIndicator(
//                   value: 1.0,
//                   strokeWidth: 12,
//                   backgroundColor: Colors.transparent,
//                   valueColor: AlwaysStoppedAnimation(Colors.grey[200]!),
//                 ),
//               ),

//               // Animated Progress Circle
//               SizedBox(
//                 width: 200,
//                 height: 200,
//                 child: CircularProgressIndicator(
//                   value: value,
//                   strokeWidth: 12,
//                   backgroundColor: Colors.transparent,
//                   valueColor: AlwaysStoppedAnimation(
//                     Helpers.getScoreColor(value * 100),
//                   ),
//                 ),
//               ),

//               // Score Text
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     '${(value * 100).round()}%',
//                     style: TextStyle(
//                       fontSize: 48,
//                       fontWeight: FontWeight.bold,
//                       color: Helpers.getScoreColor(value * 100),
//                     ),
//                   ),
//                   Text(
//                     '${result.score} من ${result.totalQuestions}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPerformanceBreakdown(ResultModel result) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'تفاصيل الأداء',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             _buildPerformanceRow(
//               icon: Icons.check_circle,
//               label: 'إجابات صحيحة',
//               value: result.correctAnswers.toString(),
//               color: AppColors.success,
//             ),

//             const Divider(height: 24),

//             _buildPerformanceRow(
//               icon: Icons.cancel,
//               label: 'إجابات خاطئة',
//               value: result.wrongAnswers.toString(),
//               color: AppColors.error,
//             ),

//             if (result.unanswered > 0) ...[
//               const Divider(height: 24),
//               _buildPerformanceRow(
//                 icon: Icons.radio_button_unchecked,
//                 label: 'لم يتم الإجابة',
//                 value: result.unanswered.toString(),
//                 color: AppColors.textSecondary,
//               ),
//             ],

//             const Divider(height: 24),

//             _buildPerformanceRow(
//               icon: Icons.timer,
//               label: 'الوقت المستغرق',
//               value: Helpers.formatDuration(result.timeTaken),
//               color: AppColors.primary,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPerformanceRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: color, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             label,
//             style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMasteryProgress(ResultModel result) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.psychology, color: AppColors.primary),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'مستوى الإتقان',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             ...result.masteryBySkill.entries.map(
//               (entry) => Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: _buildMasteryBar(
//                   skill: entry.key,
//                   percentage: entry.value,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMasteryBar({required String skill, required double percentage}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               _getSkillLabel(skill),
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             Text(
//               '${percentage.round()}%',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Helpers.getScoreColor(percentage),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: percentage / 100,
//             minHeight: 8,
//             backgroundColor: Colors.grey[200],
//             valueColor: AlwaysStoppedAnimation(
//               Helpers.getScoreColor(percentage),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     return Column(
//       children: [
//         // Review Answers Button
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: controller.reviewAnswers,
//             icon: const Icon(Icons.visibility),
//             label: const Text(
//               'مراجعة الإجابات',
//               style: TextStyle(fontSize: 16),
//             ),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 12),

//         // Retake Quiz Button
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: controller.retakeQuiz,
//             icon: const Icon(Icons.refresh),
//             label: const Text('إعادة الاختبار', style: TextStyle(fontSize: 16)),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 12),

//         // Back to Home Button
//         TextButton(
//           onPressed: controller.goHome,
//           child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 16)),
//         ),
//       ],
//     );
//   }

//   String _getSkillLabel(String skill) {
//     switch (skill) {
//       case 'remember':
//         return 'التذكر';
//       case 'understand':
//         return 'الفهم';
//       case 'apply':
//         return 'التطبيق';
//       case 'analyze':
//         return 'التحليل';
//       default:
//         return skill;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import 'result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: controller.goHome,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Obx(() {
                  final result = controller.result.value!;
                  return Column(
                    children: [
                      // Congratulations Message
                      _buildCongratsMessage(result.percentage),

                      const SizedBox(height: 32),

                      // Animated Score Circle
                      _buildScoreCircle(result),

                      const SizedBox(height: 32),

                      // اقتراح الشرح (إذا كانت النتيجة ضعيفة)
                      if (controller.showExplanationSuggestion.value)
                        _buildExplanationSuggestion(),

                      const SizedBox(height: 24),

                      // Performance Breakdown
                      _buildPerformanceBreakdown(result),

                      const SizedBox(height: 24),

                      // Mastery Progress
                      _buildMasteryProgress(result),

                      const SizedBox(height: 32),

                      // Action Buttons
                      _buildActionButtons(),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCongratsMessage(double percentage) {
    String message = '';
    String emoji = '';
    Color color = AppColors.primary;

    if (percentage >= 90) {
      message = 'ممتاز! 🎉';
      emoji = '🏆';
      color = AppColors.success;
    } else if (percentage >= 70) {
      message = 'أحسنت! 👍';
      emoji = '⭐';
      color = AppColors.primary;
    } else if (percentage >= 60) {
      message = 'جيد، يمكنك التحسن 💪';
      emoji = '📈';
      color = AppColors.warning;
    } else {
      message = 'تحتاج للمزيد من المراجعة 📚';
      emoji = '💡';
      color = AppColors.error;
    }

    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCircle(result) {
    final percentage = result.percentage;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: percentage / 100),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(Colors.grey[200]!),
                ),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    Helpers.getScoreColor(value * 100),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(value * 100).round()}%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Helpers.getScoreColor(value * 100),
                    ),
                  ),
                  Text(
                    '${result.score} من ${result.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // اقتراح الشرح للنتائج الضعيفة
  Widget _buildExplanationSuggestion() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هل تحتاج مساعدة؟',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.info,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'يمكننا شرح المواضيع التي واجهتك صعوبة فيها',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.dismissExplanationSuggestion,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textSecondary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'لا، شكراً',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: controller.requestExplanation,

                  icon: const Icon(Icons.lightbulb, size: 20),
                  label: const Text('نعم، اشرح لي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBreakdown(result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل الأداء',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildPerformanceRow(
              icon: Icons.check_circle,
              label: 'إجابات صحيحة',
              value: result.correctAnswers.toString(),
              color: AppColors.success,
            ),

            const Divider(height: 24),

            _buildPerformanceRow(
              icon: Icons.cancel,
              label: 'إجابات خاطئة',
              value: result.wrongAnswers.toString(),
              color: AppColors.error,
            ),

            if (result.unanswered > 0) ...[
              const Divider(height: 24),
              _buildPerformanceRow(
                icon: Icons.radio_button_unchecked,
                label: 'لم يتم الإجابة',
                value: result.unanswered.toString(),
                color: AppColors.textSecondary,
              ),
            ],

            const Divider(height: 24),

            _buildPerformanceRow(
              icon: Icons.timer,
              label: 'الوقت المستغرق',

              value: Helpers.formatDuration(result.timeTaken),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMasteryProgress(result) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'مستوى الإتقان',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...result.masteryBySkill.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildMasteryBar(
                  skill: entry.key,
                  percentage: entry.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasteryBar({required String skill, required double percentage}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getSkillLabel(skill),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${percentage.round()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,

                color: Helpers.getScoreColor(percentage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              Helpers.getScoreColor(percentage),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: controller.reviewAnswers,
            icon: const Icon(Icons.visibility),
            label: const Text(
              'مراجعة الإجابات',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.retakeQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة الاختبار', style: TextStyle(fontSize: 16)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: controller.goHome,

          child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  String _getSkillLabel(String skill) {
    switch (skill) {
      case 'remember':
        return 'التذكر';
      case 'understand':
        return 'الفهم';
      case 'apply':
        return 'التطبيق';
      case 'analyze':
        return 'التحليل';
      default:
        return skill;
    }
  }
}
