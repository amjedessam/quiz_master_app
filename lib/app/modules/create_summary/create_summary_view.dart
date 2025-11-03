import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/models/chapter_model.dart';
import '../../core/theme/app_colors.dart';
import 'create_summary_controller.dart';

class CreateSummaryView extends GetView<CreateSummaryController> {
  const CreateSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء ملخص')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسالة توضيحية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'اختر المادة والفصل للحصول على ملخص شامل',
                      style: TextStyle(fontSize: 14),
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

            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.subjects.map((subject) {
                  final isSelected =
                      controller.selectedSubject.value?.id == subject.id;

                  return FilterChip(
                    selected: isSelected,
                    label: Text(subject.name),
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
              ),
            ),

            const SizedBox(height: 24),

            // اختيار الفصل
            Obx(() {
              if (controller.selectedSubject.value == null) {
                return const SizedBox.shrink();
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

            const SizedBox(height: 40),

            // زر إنشاء الملخص
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isGenerating.value
                      ? null
                      : controller.generateSummary,
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
                          'إنشاء الملخص',
                          style: TextStyle(fontSize: 18),
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
