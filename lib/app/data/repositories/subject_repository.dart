import 'package:get/get.dart';

import '../models/chapter_model.dart';
import '../models/subject_model.dart';
import '../services/supabase_service.dart';

class SubjectRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Fetch subjects with stats for the current student
  Future<List<SubjectModel>> getSubjectsWithStats() async {
    final response = await _supabase.client.rpc('get_subjects_with_stats');
    if (response == null) return [];
    final list = response is List ? response : [response];
    return list
        .map((e) => SubjectModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Fetch chapters with progress for a subject
  Future<List<ChapterModel>> getChaptersWithProgress(int subjectId) async {
    final response = await _supabase.client.rpc(
      'get_chapters_with_progress',
      params: {'p_subject_id': subjectId},
    );
    if (response == null) return [];
    final list = response is List ? response : [response];
    return list
        .map((e) => ChapterModel.fromSupabase(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Fallback: fetch raw subjects (when section has no section_subjects)
  Future<List<SubjectModel>> getSubjectsForStudent() async {
    final response = await _supabase.client.rpc('get_subjects_for_student');
    if (response == null) return [];
    final list = response is List ? response : [response];
    return list
        .map((e) => SubjectModel.fromSupabase(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
