import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'subject_pdf_controller.dart';

class SubjectPdfView extends GetView<SubjectPdfController> {
  const SubjectPdfView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.subjectName),
        centerTitle: true,
        actions: [
          // عداد الصفحات
          Obx(() {
            if (controller.totalPages.value > 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${controller.currentPage.value + 1}/${controller.totalPages.value}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            }
            return const SizedBox();
          }),

          // زر التنزيل
          Obx(() {
            if (controller.isDownloading.value) {
              return Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: controller.downloadProgress.value,
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: 'تنزيل الملف',
              onPressed: controller.localPdfPath.value.isEmpty
                  ? null
                  : controller.saveToDevice,
            );
          }),
        ],
      ),

      body: Obx(() {
        // حالة التحميل
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جارٍ تحميل الملف...'),
              ],
            ),
          );
        }

        // حالة الخطأ
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(controller.errorMessage.value),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        // عرض PDF
        return PDFView(
          filePath: controller.localPdfPath.value,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          fitPolicy: FitPolicy.BOTH,
          onRender: (pages) {
            controller.totalPages.value = pages ?? 0;
          },
          onPageChanged: (page, total) {
            controller.currentPage.value = page ?? 0;
          },
          onError: (error) {
            controller.errorMessage.value = 'خطأ في عرض الملف';
          },
        );
      }),
    );
  }
}
