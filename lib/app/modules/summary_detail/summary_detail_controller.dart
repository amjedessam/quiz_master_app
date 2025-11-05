import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SummaryDetailController extends GetxController {
  final summaryData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    summaryData.value = Get.arguments as Map<String, dynamic>;
  }

  void copyContent() {
    Clipboard.setData(ClipboardData(text: summaryData.value!['content']));

    Get.snackbar(
      'تم النسخ',
      'تم نسخ المحتوى إلى الحافظة',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 2),
    );
  }

  void shareContent() {
    Get.snackbar(
      'المشاركة',
      'ميزة المشاركة ستكون متاحة قريباً',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
