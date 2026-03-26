import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SubjectPdfController extends GetxController {
  final isLoading = true.obs;
  final isDownloading = false.obs;
  final downloadProgress = 0.0.obs;
  final errorMessage = ''.obs;
  final localPdfPath = ''.obs;
  final currentPage = 0.obs;
  final totalPages = 0.obs;

  late final String pdfUrl;
  late final String subjectName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    pdfUrl = args['pdf_url'] ?? '';
    subjectName = args['subject_name'] ?? 'المادة';
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    if (pdfUrl.isEmpty) {
      errorMessage.value = 'لا يوجد ملف PDF لهذه المادة';
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(pdfUrl);
      final encodedUrl = uri.toString();

      final dir = await getTemporaryDirectory();
      final fileName = 'subject_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);
      if (!await file.exists()) {
        await Dio().download(
          encodedUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print('📥 ${(received / total * 100).toStringAsFixed(0)}%');
            }
          },
        );
      }

      localPdfPath.value = filePath;
    } catch (e) {
      errorMessage.value = 'فشل تحميل الملف. تحقق من الاتصال.';
      print('❌ PDF download error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveToDevice() async {
    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      Directory? saveDir;

      if (Platform.isAndroid) {
        // مجلد آمن يعمل على كل إصدارات Android
        saveDir = await getExternalStorageDirectory();
        saveDir = Directory('${saveDir!.path}/Downloads');
        if (!await saveDir.exists()) {
          await saveDir.create(recursive: true);
        }
      } else {
        saveDir = await getApplicationDocumentsDirectory();
      }

      final fileName =
          '${subjectName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${saveDir.path}/$fileName';

      await Dio().download(
        Uri.parse(pdfUrl).toString(),
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      Get.snackbar(
        '✅ تم التنزيل',
        'تم حفظ: $fileName',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Save error: $e');
      Get.snackbar(
        'خطأ',
        'فشل حفظ الملف',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  Future<void> retry() async {
    await _downloadPdf();
  }
}
