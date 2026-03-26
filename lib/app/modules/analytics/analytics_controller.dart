import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/practice_quiz_repository.dart';
import '../../routes/app_routes.dart';

class AnalyticsController extends GetxController
    with GetTickerProviderStateMixin {
  final PracticeQuizRepository _practiceRepo =
      Get.find<PracticeQuizRepository>();

  late TabController tabController;

  final isLoading = false.obs;

  // ── Core stats ──────────────────────────────────────────────
  final totalQuizzes = 0.obs;
  final averageScore = 0.0.obs;
  final streakDays = 0.obs;
  final totalTimeSpent = 0.obs;

  // ── Per-subject performance ──────────────────────────────────
  final subjectPerformance = <Map<String, dynamic>>[].obs;

  // ── Mastery by Bloom skill ───────────────────────────────────
  final masteryLevels = <Map<String, dynamic>>[].obs;

  // ── Chapters where accuracy < 60 % ──────────────────────────
  final weakTopics = <Map<String, dynamic>>[].obs;

  // ── Recommendations (simple list of strings) ----------------
  final recommendations = <String>[].obs;

  // ── Score per day (last 30 days) ────────────────────────────
  final performanceHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchAnalytics();
  }

  // ✅ إضافة 1: onReady — يُعيد التحميل عند كل مرة يصبح الـ controller جاهزاً
  // مهم عند العودة من صفحة الاختبار
  @override
  void onReady() {
    super.onReady();
    fetchAnalytics();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchAnalytics() async {
    isLoading.value = true;

    try {
      final analytics = await _practiceRepo.getAnalytics();

      // ── Core ────────────────────────────────────────────────
      totalQuizzes.value = (analytics['totalQuizzes'] as num?)?.toInt() ?? 0;
      averageScore.value =
          (analytics['averageScore'] as num?)?.toDouble() ?? 0.0;
      totalTimeSpent.value =
          (analytics['totalTimeSpent'] as num?)?.toInt() ?? 0;
      streakDays.value = (analytics['streakDays'] as num?)?.toInt() ?? 0;

      // ── Subject performance ─────────────────────────────────
      final perf = analytics['subjectPerformance'];
      if (perf is List) {
        subjectPerformance.value = perf
            .map(
              (e) => {
                'name': (e as Map)['name']?.toString() ?? '',
                'score': ((e['score'] as num?)?.toDouble()) ?? 0.0,
                'quizzes': (e['quizzes'] as num?)?.toInt() ?? 0,
                'color': '0xFF6C63FF',
              },
            )
            .toList();
      } else {
        subjectPerformance.value = [];
      }

      // ── Performance history ─────────────────────────────────
      final hist = analytics['performanceHistory'];
      if (hist is List) {
        performanceHistory.value = hist.map((e) {
          final map = e as Map;
          final dateStr = map['date']?.toString() ?? '';
          return {
            'date': dateStr,
            // provide a short 'day' label for the view (safe fallback)
            'day': dateStr,
            'score': ((map['score'] as num?)?.toDouble()) ?? 0.0,
            'quizzes': (map['quizzes'] as num?)?.toInt() ?? 0,
          };
        }).toList();
      } else {
        performanceHistory.value = [];
      }

      // ── Weak topics ─────────────────────────────────────────
      final weak = analytics['weakTopics'];
      if (weak is List) {
        weakTopics.value = weak
            .map(
              (e) => {
                'chapter': (e as Map)['chapter']?.toString() ?? '',
                'name': (e as Map)['chapter']?.toString() ?? '',
                'subject': e['subject']?.toString() ?? '',
                'chapter_id': (e['chapter_id'] as num?)?.toInt(),
                'accuracy': ((e['accuracy'] as num?)?.toDouble()) ?? 0.0,
                'rate': ((e['accuracy'] as num?)?.toDouble()) ?? 0.0,
                'attempts': (e['attempts'] as num?)?.toInt() ?? 0,
              },
            )
            .toList();
      } else {
        weakTopics.value = [];
      }

      // ── Mastery levels ─────────────────────────────────────
      final mastery = analytics['masteryLevels'];
      if (mastery is List) {
        masteryLevels.value = mastery
            .map(
              (e) => {
                'skill': (e as Map)['skill']?.toString() ?? '',
                'accuracy': ((e['accuracy'] as num?)?.toDouble()) ?? 0.0,
                'percentage': ((e['accuracy'] as num?)?.toDouble()) ?? 0.0,
                'total_answers': (e['total_answers'] as num?)?.toInt() ?? 0,
              },
            )
            .toList();
      } else {
        masteryLevels.value = [];
      }

      // ── Recommendations (optional) -----------------------------
      final recs = analytics['recommendations'];
      if (recs is List) {
        recommendations.value = recs.map((r) => r?.toString() ?? '').toList();
      } else {
        recommendations.value = [];
      }
    } catch (e) {
      // ✅ إضافة 2: لا تخفي الأخطاء — اطبعها للتشخيص
      debugPrint('❌ fetchAnalytics error: $e');
      subjectPerformance.value = [];
      performanceHistory.value = [];
      weakTopics.value = [];
      masteryLevels.value = [];
    } finally {
      isLoading.value = false;
      debugPrint(
        '📊 Analytics loaded — masteryLevels: ${masteryLevels.length} | weakTopics: ${weakTopics.length}',
      );
    }
  }

  /// Navigate to Explanation screen for a weak chapter
  void explainWeakTopic(Map<String, dynamic> topic) {
    final chapterId = topic['chapter_id'] as int?;
    final topicName = topic['chapter']?.toString() ?? '';

    Get.toNamed(
      AppRoutes.EXPLANATION,
      arguments: {
        'mode': 'manual',
        'chapter_id': chapterId,
        'topic_hint': topicName,
      },
    );
  }

  void goToHistory() {
    Get.toNamed(AppRoutes.HISTORY);
  }
}
