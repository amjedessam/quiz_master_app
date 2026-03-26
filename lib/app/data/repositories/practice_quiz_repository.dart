import 'package:get/get.dart';

import '../services/supabase_service.dart';

class PracticeQuizRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Save a practice quiz attempt
  Future<int> saveAttempt({
    required int subjectId,
    required int chapterId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    required int unanswered,
    required int timeTakenSeconds,
    Map<String, dynamic>? quizOptions,
    required List<Map<String, dynamic>> answers,
  }) async {
    final answersJson = answers
        .map((a) => {
              'question_id': a['question_id'],
              'selected_answer': a['selected_answer'],
              'is_correct': a['is_correct'],
            })
        .toList();

    final response = await _supabase.client.rpc(
      'save_practice_quiz_attempt',
      params: {
        'p_subject_id': subjectId,
        'p_chapter_id': chapterId,
        'p_score': score,
        'p_total_questions': totalQuestions,
        'p_correct_answers': correctAnswers,
        'p_wrong_answers': wrongAnswers,
        'p_unanswered': unanswered,
        'p_time_taken_seconds': timeTakenSeconds,
        'p_quiz_options': quizOptions ?? {},
        'p_answers': answersJson,
      },
    );
    return response as int;
  }

  /// Fetch quiz history for the student
  Future<List<Map<String, dynamic>>> getHistory({int limit = 50}) async {
    final response = await _supabase.client.rpc(
      'get_student_quiz_history',
      params: {'p_limit': limit},
    );
    if (response == null) return [];
    final list = response is List ? response : [response];
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Fetch analytics for the student
  Future<Map<String, dynamic>> getAnalytics() async {
    final response = await _supabase.client.rpc('get_student_analytics');
    if (response == null) return {};
    return Map<String, dynamic>.from(response as Map);
  }
}
