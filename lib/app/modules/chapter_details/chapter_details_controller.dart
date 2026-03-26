import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_routes.dart';

class ChapterDetailsController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  final subject = Rxn<SubjectModel>();
  final chapter = Rxn<ChapterModel>();
  final isLoading = false.obs;

  /// Real topics from chapter_topics table
  final topics = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    subject.value = args['subject'];
    chapter.value = args['chapter'];
    _loadChapterTopics();
  }

  Future<void> _loadChapterTopics() async {
    isLoading.value = true;

    try {
      final chapterId = int.tryParse(chapter.value?.id ?? '');
      if (chapterId == null) {
        topics.value = [];
        return;
      }

      final response = await _supabase.client.rpc(
        'get_chapter_topics',
        params: {'p_chapter_id': chapterId},
      );

      if (response == null) {
        topics.value = [];
        return;
      }

      final list = response is List ? response : [response];
      topics.value = list.map((e) {
        final row = Map<String, dynamic>.from(e as Map);
        final durationMin = (row['duration_min'] as num?)?.toInt() ?? 0;
        return {
          'id': row['id']?.toString() ?? '',
          'title': row['title']?.toString() ?? '',
          'description': row['description']?.toString() ?? '',
          'duration': durationMin > 0 ? '$durationMin دقيقة' : '',
          'questionsCount': (row['questions_count'] as num?)?.toInt() ?? 0,
          // isCompleted will be computed in a future iteration
          // from practice_quiz_answers coverage per topic
          'isCompleted': false,
        };
      }).toList();
    } catch (_) {
      topics.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void startQuiz() {
    Get.toNamed(
      AppRoutes.MainTabView,
      arguments: {
        'subject': subject.value,
        'chapter': chapter.value,
        'autoSelect': true,
      },
    );
  }

  void viewSummary() {
    _generateSummaryDirectly();
  }

  void requestExplanation() {
    Get.toNamed(
      AppRoutes.EXPLANATION,
      arguments: {
        'mode': 'manual',
        'chapter_id': int.tryParse(chapter.value?.id ?? ''),
        'topic_hint': chapter.value?.name ?? '',
      },
    );
  }

  void viewTopic(Map<String, dynamic> topic) {
    Get.snackbar(
      'الموضوع: ${topic['title']}',
      topic['description']?.toString().isNotEmpty == true
          ? topic['description'].toString()
          : 'لا يوجد وصف متاح',
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> refreshData() => _loadChapterTopics();

  Future<void> _generateSummaryDirectly() async {
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري إنشاء الملخص...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));
    Get.back();

    Get.toNamed(
      AppRoutes.CREATE_SUMMARY,
      arguments: {'subject': subject.value, 'chapter': chapter.value},
    );
  }
}
