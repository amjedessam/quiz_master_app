import 'package:get/get.dart';
import 'package:quiz_master_app/app/routes/app_routes.dart';
import '../../data/services/supabase_service.dart';

class SummariesController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  final selectedTab     = 0.obs;
  final isLoading       = false.obs;
  final summariesHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSummaries();
  }

  Future<void> fetchSummaries() async {
    isLoading.value = true;

    try {
      final response = await _supabase.client.rpc(
        'get_student_summaries',
        params: {'p_limit': 50},
      );

      if (response == null) {
        summariesHistory.value = [];
        return;
      }

      final list = response is List ? response : [response];
      summariesHistory.value = list.map((e) {
        final row = Map<String, dynamic>.from(e as Map);
        DateTime? date;
        if (row['created_at'] != null) {
          date = DateTime.tryParse(row['created_at'].toString()) ??
              DateTime.now();
        } else {
          date = DateTime.now();
        }
        return {
          'id':      row['id']?.toString(),
          'type':    row['summary_type']?.toString() ?? 'summary',
          'title':   row['title']?.toString() ?? '',
          'subject': row['subject_name']?.toString() ?? '',
          'chapter': row['chapter_name']?.toString() ?? '',
          'date':    date,
          'content': row['content']?.toString() ?? '',
          'subject_id': row['subject_id'],
          'chapter_id': row['chapter_id'],
        };
      }).toList();
    } catch (_) {
      summariesHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> deleteSummary(String id) async {
    try {
      final summaryId = int.tryParse(id);
      if (summaryId == null) return;

      await _supabase.client.rpc(
        'delete_student_summary',
        params: {'p_summary_id': summaryId},
      );

      summariesHistory.removeWhere((s) => s['id'] == id);
    } catch (_) {
      // Silently fail — item stays in list if delete fails
    }
  }

  Future<void> refreshSummaries() => fetchSummaries();
}
