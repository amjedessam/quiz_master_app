import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/data/models/chapter_model.dart';
import '../../core/theme/app_colors.dart';
import 'explanation_controller.dart';

class ExplanationView extends GetView<ExplanationController> {
  const ExplanationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشرح الذكي')),
      body: Obx(() {
        if (controller.showExplanation.value) {
          return _buildExplanationContent();
        } else if (controller.mode.value == 'auto') {
          return _buildLoadingState();
        } else {
          return _buildManualForm();
        }
      }),
    );
  }

  Widget _buildManualForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.school, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اطلب شرح لأي موضوع تريد فهمه',
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
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          Obx(() {
            if (controller.selectedSubject.value == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر الفصل (اختياري)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ChapterModel>(
                  value: controller.selectedChapter.value,
                  decoration: const InputDecoration(
                    hintText: 'اختر الفصل أو اتركه فارغاً',
                  ),
                  items: [
                    const DropdownMenuItem<ChapterModel>(
                      value: null,
                      child: Text('جميع الفصول'),
                    ),
                    ...controller.chapters.map((chapter) {
                      return DropdownMenuItem<ChapterModel>(
                        value: chapter,
                        child: Text(chapter.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (chapter) {
                    if (chapter != null) {
                      controller.selectChapter(chapter);
                    }
                  },
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          const Text(
            'ما الموضوع الذي تريد شرحه؟',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: controller.topicController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText:
                  'مثال: المتجهات في الفضاء، قانون نيوتن الثاني، التفاعلات الكيميائية...',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 40),

          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isGenerating.value
                    ? null
                    : controller.requestManualExplanation,
                icon: controller.isGenerating.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.lightbulb),
                label: Text(
                  controller.isGenerating.value ? 'جاري التحضير...' : 'اشرح لي',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text(
            'جاري تحليل نتيجتك وإعداد الشرح...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 30,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تم إعداد الشرح بنجاح!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => Text(
                    controller.explanation.value,
                    style: const TextStyle(fontSize: 16, height: 1.8),
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
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
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: controller.explanation.value),
                      );
                      Get.snackbar(
                        'تم النسخ',
                        'تم نسخ الشرح إلى الحافظة',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.success,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.check),
                    label: const Text('فهمت'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
