import 'package:get/get.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../services/supabase_service.dart';

class AssignedExamRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // ── جلب الاختبارات المُرسلة للطالب ────────────────────────────────────────
  Future<List<AssignedExamItem>> getAssignedExams() async {
    final res = await _supabase.client
        .from('exam_assignments')
        .select('''
          id,
          status,
          assigned_at,
          due_date,
          exams (
            id,
            title,
            description,
            total_marks,
            passing_marks,
            duration_minutes,
            difficulty_level,
            subject_id,
            subjects ( name )
          )
        ''')
        .eq('status', 'pending')
        .order('assigned_at', ascending: false);

    final list = res as List;
    return list
        .map(
          (e) => AssignedExamItem.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  // ── جلب أسئلة اختبار معيّن وتحويله لـ QuizModel ──────────────────────────
  Future<QuizModel> loadExamAsQuiz(AssignedExamItem item) async {
    final res = await _supabase.client
        .from('exam_questions')
        .select('''
          question_order,
          marks,
          questions (
            id,
            question_text,
            question_type,
            question_options,
            correct_answer,
            explanation,
            difficulty_level,
            skill,
            reference_page,
            subject_id,
            chapter_id
          )
        ''')
        .eq('exam_id', item.examId)
        .order('question_order', ascending: true);

    final list = res as List;
    final questions = list.map((e) {
      final q = Map<String, dynamic>.from(e['questions'] as Map);
      return QuestionModel.fromJson(q);
    }).toList();

    return QuizModel(
      id: item.examId.toString(),
      subjectId: item.subjectId.toString(),
      subjectName: item.subjectName,
      chapterId: '0', // اختبار رسمي — لا يحتاج chapterId
      chapterName: item.examTitle,
      questions: questions,
      createdAt: item.assignedAt,
      timeLimit: item.durationMinutes * 60,
      isAssignedExam: true, // ✅ علامة للتمييز عن التدريب الذاتي
      assignmentId: item.id,
    );
  }

  // ── حفظ نتيجة الاختبار الرسمي ─────────────────────────────────────────────

  Future<void> saveExamResult({
    required int assignmentId,
    required int examId,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    required int timeTakenSeconds,
    required List<Map<String, dynamic>> answers,
  }) async {
    final percentage = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).roundToDouble()
        : 0.0;

    // await _supabase.client.from('exam_results').insert({
    //   'exam_id': examId,
    //   'obtained_marks': correctAnswers, // ✅
    //   'total_marks': totalQuestions, // ✅
    //   // 'percentage': percentage,
    //   'status': 'completed',
    //   'answers': answers,
    //   'submitted_at': DateTime.now().toIso8601String(),
    //   // ❌ حذف: correct_answers, wrong_answers, score, total_questions
    // });
    final userId = _supabase.client.auth.currentUser?.id;
    final studentRes = await _supabase.client
        .from('app_user')
        .select('app_entity_id')
        .eq('auth_user_id', userId!)
        .single();
    final studentId = studentRes['app_entity_id'] as int;

    await _supabase.client.from('exam_results').insert({
      'exam_id': examId,
      'student_id': studentId, // ✅ مطلوب للـ RLS
      'obtained_marks': correctAnswers,
      'total_marks': totalQuestions,
      'status': 'completed',
      'answers': answers,
      'submitted_at': DateTime.now().toIso8601String(),
    });
    await _supabase.client
        .from('exam_assignments')
        .update({'status': 'completed'})
        .eq('id', assignmentId);
  }
}

// ── Model بسيط للعرض في القائمة ───────────────────────────────────────────
class AssignedExamItem {
  final int id; // assignment id
  final int examId;
  final String examTitle;
  final String? examDescription;
  final int totalMarks;
  final int passingMarks;
  final int durationMinutes;
  final String subjectId;
  final String subjectName;
  final String status;
  final DateTime assignedAt;
  final DateTime? dueDate;

  AssignedExamItem({
    required this.id,
    required this.examId,
    required this.examTitle,
    this.examDescription,
    required this.totalMarks,
    required this.passingMarks,
    required this.durationMinutes,
    required this.subjectId,
    required this.subjectName,
    required this.status,
    required this.assignedAt,
    this.dueDate,
  });

  factory AssignedExamItem.fromJson(Map<String, dynamic> json) {
    final exam = Map<String, dynamic>.from(json['exams'] as Map);
    final subject = exam['subjects'] != null
        ? Map<String, dynamic>.from(exam['subjects'] as Map)
        : <String, dynamic>{};

    return AssignedExamItem(
      id: json['id'] as int,
      examId: exam['id'] as int,
      examTitle: exam['title']?.toString() ?? '',
      examDescription: exam['description']?.toString(),
      totalMarks: exam['total_marks'] as int? ?? 0,
      passingMarks: exam['passing_marks'] as int? ?? 0,
      durationMinutes: exam['duration_minutes'] as int? ?? 30,
      subjectId: exam['subject_id']?.toString() ?? '0',
      subjectName: subject['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      assignedAt: DateTime.parse(json['assigned_at'].toString()),
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'].toString())
          : null,
    );
  }
}
