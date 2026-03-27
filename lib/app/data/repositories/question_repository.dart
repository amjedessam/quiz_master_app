import 'package:get/get.dart';

import '../models/question_model.dart';
import '../services/supabase_service.dart';

class QuestionRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Fetch questions for a practice quiz
  /// [chapterId] - chapter id
  /// [count] - number of questions
  /// [difficulty] - 'easy', 'medium', 'hard', or null for mixed
  Future<List<QuestionModel>> getQuestionsForQuiz({
    required int chapterId,
    int count = 10,
    String? difficulty,
    List<String>? types,
  }) async {
    final response = await _supabase.client.rpc(
      'get_questions_for_quiz',
      params: {
        'p_chapter_id': chapterId,
        'p_count': count,
        'p_difficulty': difficulty,
        // 'p_types': types,
        'p_types': types != null ? '{${types.join(',')}}' : null,
      },
    );
    if (response == null) return [];
    final list = response is List ? response : [response];
    return list
        .map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
