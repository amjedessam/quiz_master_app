import 'package:get/get.dart';

class HistoryController extends GetxController {
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
    await Future.delayed(const Duration(milliseconds: 500));

    quizHistory.value = [
      {
        'id': '1',
        'subject': 'الرياضيات',
        'chapter': 'الفصل الثالث: التطبيقات',
        'score': 18,
        'total': 20,
        'percentage': 90.0,
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'duration': 780, // seconds
      },
      {
        'id': '2',
        'subject': 'الفيزياء',
        'chapter': 'الفصل الثاني: المفاهيم الأساسية',
        'score': 14,
        'total': 20,
        'percentage': 70.0,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'duration': 900,
      },
      {
        'id': '3',
        'subject': 'الكيمياء',
        'chapter': 'الفصل الأول: المقدمة',
        'score': 16,
        'total': 20,
        'percentage': 80.0,
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'duration': 720,
      },
      {
        'id': '4',
        'subject': 'الرياضيات',
        'chapter': 'الفصل الثاني: المفاهيم الأساسية',
        'score': 17,
        'total': 20,
        'percentage': 85.0,
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'duration': 840,
      },
      {
        'id': '5',
        'subject': 'الأحياء',
        'chapter': 'الفصل الأول: المقدمة',
        'score': 12,
        'total': 20,
        'percentage': 60.0,
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'duration': 960,
      },
      {
        'id': '6',
        'subject': 'الفيزياء',
        'chapter': 'الفصل الثالث: التطبيقات',
        'score': 15,
        'total': 20,
        'percentage': 75.0,
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'duration': 810,
      },
    ];

    isLoading.value = false;
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
