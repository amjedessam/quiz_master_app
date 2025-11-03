import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import 'summary_detail_controller.dart';

class SummaryDetailView extends GetView<SummaryDetailController> {
  const SummaryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التفاصيل'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: controller.copyContent,
            tooltip: 'نسخ',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.shareContent,
            tooltip: 'مشاركة',
          ),
        ],
      ),
      body: Obx(() {
        final data = controller.summaryData.value!;
        final title = data['title'] as String;
        final subject = data['subject'] as String;
        final date = data['date'] as DateTime;
        final content = data['content'] as String;
        final type = data['type'] as String;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // المعلومات
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: type == 'summary'
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type == 'summary' ? Icons.summarize : Icons.school,
                          size: 16,
                          color: type == 'summary'
                              ? AppColors.primary
                              : AppColors.info,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          type == 'summary' ? 'ملخص' : 'شرح',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: type == 'summary'
                                ? AppColors.primary
                                : AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // المحتوى
              Text(content, style: const TextStyle(fontSize: 16, height: 1.8)),
            ],
          ),
        );
      }),
    );
  }
}
