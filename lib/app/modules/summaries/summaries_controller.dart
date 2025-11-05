import 'package:get/get.dart';
import 'package:quiz_master_app/app/routes/app_routes.dart';

class SummariesController extends GetxController {
  final selectedTab = 0.obs;
  final summariesHistory = <Map<String, dynamic>>[
    {
      'id': '1',
      'type': 'summary',
      'title': 'ملخص: الفصل الثالث - التطبيقات',
      'subject': 'الرياضيات',
      'chapter': 'الفصل الثالث',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'content': 'هذا ملخص شامل للفصل الثالث...',
    },
    {
      'id': '2',
      'type': 'explanation',
      'title': 'شرح: المتجهات في الفضاء',
      'subject': 'الرياضيات',
      'chapter': 'الفصل الثاني',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'content': 'شرح مفصل للمتجهات...',
    },
  ].obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void createSummary() {
    Get.toNamed(AppRoutes.CREATE_SUMMARY);
  }

  void requestExplanation() {
    Get.toNamed(AppRoutes.EXPLANATION, arguments: {'mode': 'manual'});
  }

  void viewSummaryDetail(Map<String, dynamic> summary) {
    Get.toNamed(AppRoutes.SUMMARY_DETAIL, arguments: summary);
  }

  void deleteSummary(String id) {
    summariesHistory.removeWhere((s) => s['id'] == id);
  }
}
