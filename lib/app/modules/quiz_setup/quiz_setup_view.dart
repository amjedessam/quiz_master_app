// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// // import '../../core/utils/helpers.dart';
// import 'quiz_setup_controller.dart';

// class QuizSetupView extends GetView<QuizSetupController> {
//   const QuizSetupView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('إعداد الاختبار')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Subject & Chapter Info
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             controller.subject.value?.icon ?? '',
//                             style: const TextStyle(fontSize: 40),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   controller.subject.value?.name ?? '',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   controller.chapter.value?.name ?? '',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Question Count
//             const Text(
//               'عدد الأسئلة',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Obx(
//                       () => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('عدد الأسئلة'),
//                           Text(
//                             '${controller.questionCount.value}',
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Obx(
//                       () => Slider(
//                         value: controller.questionCount.value.toDouble(),
//                         min: 5,
//                         max: 30,
//                         divisions: 25,
//                         label: controller.questionCount.value.toString(),
//                         onChanged: controller.updateQuestionCount,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24), // Difficulty Level
//             const Text(
//               'مستوى الصعوبة',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             Obx(
//               () => Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: [
//                   _buildDifficultyChip('easy', 'سهل', AppColors.easyColor),
//                   _buildDifficultyChip(
//                     'medium',
//                     'متوسط',
//                     AppColors.mediumColor,
//                   ),
//                   _buildDifficultyChip('hard', 'صعب', AppColors.hardColor),
//                   _buildDifficultyChip('mixed', 'متنوع', AppColors.primary),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Question Types
//             const Text(
//               'نوع الأسئلة',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             Obx(
//               () => Column(
//                 children: [
//                   _buildTypeCheckbox(
//                     'multiple_choice',
//                     'اختيار من متعدد',
//                     Icons.list,
//                   ),
//                   SizedBox(height: 8),
//                   _buildTypeCheckbox(
//                     'true_false',
//                     'صح وخطأ',
//                     Icons.check_circle_outline,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),

//             // Generate Button
//             Obx(
//               () => SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: controller.isGenerating.value
//                       ? null
//                       : controller.generateQuiz,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                   ),
//                   child: controller.isGenerating.value
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : const Text(
//                           'إنشاء الاختبار',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDifficultyChip(String value, String label, Color color) {
//     final isSelected = controller.selectedDifficulty.value == value;

//     return FilterChip(
//       selected: isSelected,
//       label: Text(label),
//       onSelected: (_) => controller.selectDifficulty(value),
//       backgroundColor: Colors.white,
//       selectedColor: color.withOpacity(0.2),
//       checkmarkColor: color,
//       side: BorderSide(
//         color: isSelected ? color : AppColors.border,
//         width: isSelected ? 2 : 1,
//       ),
//       labelStyle: TextStyle(
//         color: isSelected ? color : AppColors.textPrimary,
//         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//       ),
//     );
//   }

//   Widget _buildTypeCheckbox(String type, String label, IconData icon) {
//     final isSelected = controller.selectedTypes.contains(type);

//     return Card(
//       child: CheckboxListTile(
//         value: isSelected,
//         onChanged: (_) => controller.toggleQuestionType(type),
//         title: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? AppColors.primary : AppColors.textSecondary,
//             ),
//             const SizedBox(width: 12),
//             Text(label),
//           ],
//         ),
//         activeColor: AppColors.primary,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quiz_master_app/app/data/models/chapter_model.dart';
// import '../../core/theme/app_colors.dart';
// // import '../../core/utils/helpers.dart';
// import 'quiz_setup_controller.dart';

// class QuizSetupView extends GetView<QuizSetupController> {
//   const QuizSetupView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('إعداد الاختبار')

//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // رسالة توضيحية
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: AppColors.primaryGradient,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.quiz, color: Colors.white, size: 30),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'اختر المادة والفصل لبدء الاختبار',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // اختيار المادة
//             const Text(
//               'اختر المادة',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             Obx(() {
//               if (controller.subjects.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(20),
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }

//               return Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: controller.subjects.map((subject) {
//                   final isSelected =
//                       controller.selectedSubject.value?.id == subject.id;

//                   return FilterChip(
//                     selected: isSelected,
//                     label: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(subject.icon),
//                         const SizedBox(width: 6),
//                         Text(subject.name),
//                       ],
//                     ),
//                     onSelected: (_) => controller.selectSubject(subject),
//                     backgroundColor: Colors.white,
//                     selectedColor: AppColors.primary.withOpacity(0.2),
//                     checkmarkColor: AppColors.primary,
//                     side: BorderSide(
//                       color: isSelected ? AppColors.primary : AppColors.border,
//                       width: isSelected ? 2 : 1,
//                     ),
//                     labelStyle: TextStyle(
//                       color: isSelected
//                           ? AppColors.primary
//                           : AppColors.textPrimary,
//                       fontWeight: isSelected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   );
//                 }).toList(),
//               );
//             }),

//             const SizedBox(height: 24),

//             // اختيار الفصل
//             Obx(() {
//               if (controller.selectedSubject.value == null) {
//                 return const SizedBox.shrink();
//               }

//               if (controller.chapters.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(20),
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'اختر الفصل',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   ...controller.chapters.map((chapter) {
//                     final isSelected =
//                         controller.selectedChapter.value?.id == chapter.id;

//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       elevation: isSelected ? 3 : 1,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         side: BorderSide(
//                           color: isSelected
//                               ? AppColors.primary
//                               : Colors.transparent,
//                           width: 2,
//                         ),
//                       ),
//                       child: RadioListTile<ChapterModel>(
//                         value: chapter,
//                         groupValue: controller.selectedChapter.value,
//                         onChanged: (value) => controller.selectChapter(chapter),
//                         title: Text(
//                           chapter.name,
//                           style: TextStyle(
//                             fontWeight: isSelected
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                         ),
//                         subtitle: Text(
//                           '${chapter.questionsCount} سؤال',
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         activeColor: AppColors.primary,
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               );
//             }),

//             Obx(() {
//               if (controller.selectedChapter.value == null) {
//                 return const SizedBox.shrink();
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 24),

//                   // عدد الأسئلة
//                   const Text(
//                     'عدد الأسئلة',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 12),

//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Obx(
//                             () => Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('عدد الأسئلة'),
//                                 Text(
//                                   '${controller.questionCount.value}',
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColors.primary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Obx(
//                             () => Slider(
//                               value: controller.questionCount.value.toDouble(),
//                               min: 5,
//                               max: 30,
//                               divisions: 25,
//                               label: controller.questionCount.value.toString(),
//                               onChanged: controller.updateQuestionCount,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // مستوى الصعوبة
//                   const Text(
//                     'مستوى الصعوبة',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 12),

//                   Obx(
//                     () => Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: [
//                         _buildDifficultyChip(
//                           'easy',
//                           'سهل',
//                           AppColors.easyColor,
//                         ),
//                         _buildDifficultyChip(
//                           'medium',
//                           'متوسط',
//                           AppColors.mediumColor,
//                         ),
//                         _buildDifficultyChip(
//                           'hard',
//                           'صعب',
//                           AppColors.hardColor,
//                         ),
//                         _buildDifficultyChip(
//                           'mixed',
//                           'متنوع',
//                           AppColors.primary,
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // نوع الأسئلة
//                   const Text(
//                     'نوع الأسئلة',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 12),

//                   Obx(
//                     () => Column(
//                       children: [
//                         _buildTypeCheckbox(
//                           'multiple_choice',
//                           'اختيار من متعدد',
//                           Icons.list,
//                         ),
//                         SizedBox(height: 5),
//                         _buildTypeCheckbox(
//                           'true_false',
//                           'صح وخطأ',
//                           Icons.check_circle_outline,
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // زر إنشاء الاختبار
//                   Obx(
//                     () => SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: controller.isGenerating.value
//                             ? null
//                             : controller.generateQuiz,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 18),
//                         ),
//                         child: controller.isGenerating.value
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                             : const Text(
//                                 'إنشاء الاختبار',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDifficultyChip(String value, String label, Color color) {
//     final isSelected = controller.selectedDifficulty.value == value;

//     return FilterChip(
//       selected: isSelected,
//       label: Text(label),
//       onSelected: (_) => controller.selectDifficulty(value),
//       backgroundColor: Colors.white,
//       selectedColor: color.withOpacity(0.2),
//       checkmarkColor: color,
//       side: BorderSide(
//         color: isSelected ? color : AppColors.border,
//         width: isSelected ? 2 : 1,
//       ),
//       labelStyle: TextStyle(
//         color: isSelected ? color : AppColors.textPrimary,
//         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//       ),
//     );
//   }

//   Widget _buildTypeCheckbox(String type, String label, IconData icon) {
//     final isSelected = controller.selectedTypes.contains(type);

//     return Card(
//       child: CheckboxListTile(
//         value: isSelected,
//         onChanged: (_) => controller.toggleQuestionType(type),
//         title: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? AppColors.primary : AppColors.textSecondary,
//             ),
//             const SizedBox(width: 12),
//             Text(label),
//           ],
//         ),
//         activeColor: AppColors.primary,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/models/chapter_model.dart';
import 'package:quiz_master_app/app/modules/history/history_controller.dart';
import '../../core/theme/app_colors.dart';
import '../history/history_view.dart';
import 'quiz_setup_controller.dart';

class QuizSetupView extends GetView<QuizSetupController> {
  const QuizSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إعداد الاختبار'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الاختبار'),
              Tab(text: 'السجل'),
            ],
          ),
        ),
        // body: const TabBarView(children: [_QuizSetupContent(), HistoryView()]),
        body: TabBarView(
          children: [
            const _QuizSetupContent(),
            Builder(
              builder: (context) {
                // تسجيل الكنترولر عند الحاجة فقط (مرة واحدة)
                if (!Get.isRegistered<HistoryController>()) {
                  Get.lazyPut(() => HistoryController());
                }
                return const HistoryView();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizSetupContent extends GetView<QuizSetupController> {
  const _QuizSetupContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رسالة توضيحية
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.quiz, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اختر المادة والفصل لبدء الاختبار',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // اختيار المادة
          const Text(
            'اختر المادة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.subjects.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.subjects.map((subject) {
                final isSelected =
                    controller.selectedSubject.value?.id == subject.id;

                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(subject.icon),
                      const SizedBox(width: 6),
                      Text(subject.name),
                    ],
                  ),
                  onSelected: (_) => controller.selectSubject(subject),
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 24),
          // اختيار الفصل
          Obx(() {
            if (controller.selectedSubject.value == null) {
              return const SizedBox.shrink();
            }

            if (controller.chapters.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر الفصل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...controller.chapters.map((chapter) {
                  final isSelected =
                      controller.selectedChapter.value?.id == chapter.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: isSelected ? 3 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: RadioListTile<ChapterModel>(
                      value: chapter,
                      groupValue: controller.selectedChapter.value,
                      onChanged: (value) => controller.selectChapter(chapter),
                      title: Text(
                        chapter.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        '${chapter.questionsCount} سؤال',
                        style: const TextStyle(fontSize: 12),
                      ),
                      activeColor: AppColors.primary,
                    ),
                  );
                }).toList(),
              ],
            );
          }),

          // إعدادات إضافية
          Obx(() {
            if (controller.selectedChapter.value == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'عدد الأسئلة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('عدد الأسئلة'),
                              Text(
                                '${controller.questionCount.value}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Slider(
                            value: controller.questionCount.value.toDouble(),
                            min: 5,
                            max: 30,
                            divisions: 25,
                            label: controller.questionCount.value.toString(),
                            onChanged: controller.updateQuestionCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // مستوى الصعوبة
                const Text(
                  'مستوى الصعوبة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildDifficultyChip('easy', 'سهل', AppColors.easyColor),
                      _buildDifficultyChip(
                        'medium',
                        'متوسط',
                        AppColors.mediumColor,
                      ),
                      _buildDifficultyChip('hard', 'صعب', AppColors.hardColor),
                      _buildDifficultyChip('mixed', 'متنوع', AppColors.primary),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // نوع الأسئلة
                const Text(
                  'نوع الأسئلة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Column(
                    children: [
                      _buildTypeCheckbox(
                        'multiple_choice',
                        'اختيار من متعدد',
                        Icons.list,
                      ),
                      const SizedBox(height: 5),
                      _buildTypeCheckbox(
                        'true_false',
                        'صح وخطأ',
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // زر إنشاء الاختبار
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isGenerating.value
                          ? null
                          : controller.generateQuiz,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: controller.isGenerating.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'إنشاء الاختبار',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String value, String label, Color color) {
    final isSelected = controller.selectedDifficulty.value == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) => controller.selectDifficulty(value),
      backgroundColor: Colors.white,
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      side: BorderSide(
        color: isSelected ? color : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTypeCheckbox(String type, String label, IconData icon) {
    final isSelected = controller.selectedTypes.contains(type);

    return Card(
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (_) => controller.toggleQuestionType(type),
        title: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
        activeColor: AppColors.primary,
      ),
    );
  }
}
