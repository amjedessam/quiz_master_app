import 'package:get/get.dart';

import '../../data/repositories/practice_quiz_repository.dart';

class HistoryController extends GetxController {
  final PracticeQuizRepository _practiceRepo = Get.find<PracticeQuizRepository>();

  final isLoading = false.obs;
  final quizHistory = <Map<String, dynamic>>[].obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;

    try {
      final list = await _practiceRepo.getHistory(limit: 50);
      quizHistory.value = list.map((e) {
        DateTime? date;
        if (e['completed_at'] != null) {
          date = DateTime.tryParse(e['completed_at'].toString()) ??
              DateTime.now();
        } else {
          date = DateTime.now();
        }
        return {
          'id': e['id']?.toString(),
          'subject': e['subject_name'],
          'chapter': e['chapter_name'],
          'score': (e['score'] as num?)?.toInt(),
          'total': (e['total_questions'] as num?)?.toInt(),
          'percentage': (e['percentage'] as num?)?.toDouble(),
          'date': date,
          'duration': (e['time_taken_seconds'] as num?)?.toInt() ?? 0,
        };
      }).toList();
    } catch (e) {
      quizHistory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<Map<String, dynamic>> get filteredHistory {
    final now = DateTime.now();

    switch (selectedFilter.value) {
      case 'today':
        return quizHistory.where((quiz) {
          final date = quiz['date'] as DateTime;
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        }).toList();
      case 'week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return quizHistory.where((quiz) {
          final date = quiz['date'] as DateTime;
          return date.isAfter(weekAgo);
        }).toList();
      case 'month':
        final monthAgo = now.subtract(const Duration(days: 30));
        return quizHistory.where((quiz) {
          final date = quiz['date'] as DateTime;
          return date.isAfter(monthAgo);
        }).toList();
      default:
        return quizHistory;
    }
  }

  void viewQuizDetails(Map<String, dynamic> quiz) {}

  Future<void> refreshHistory() async {
    await fetchHistory();
  }
}
