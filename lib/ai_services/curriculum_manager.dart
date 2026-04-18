import 'dart:convert';
import 'models.dart';

/// Curriculum Manager - إدارة المنهج الدراسي
class CurriculumManager {
  final Map<String, Stage> _stages = {};

  /// Load curriculum from JSON
  Future<void> loadCurriculumFromJson(String jsonData) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData);

      List<Stage> stages;
      if (data.containsKey('stages')) {
        stages = (data['stages'] as List)
            .map((s) => Stage.fromJson(s as Map<String, dynamic>))
            .toList();
      } else if (data.containsKey('education_levels')) {
        stages = (data['education_levels'] as List)
            .map((level) => _parseEducationLevel(level as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unsupported curriculum format');
      }

      for (var stage in stages) {
        _stages[stage.id] = stage;
      }
    } catch (e) {
      throw Exception('Failed to load curriculum: $e');
    }
  }

Stage _parseEducationLevel(Map<String, dynamic> json) {
  final semesters = (json['semesters'] as List? ?? [])
      .map((semJson) {
        final sem = semJson as Map<String, dynamic>;

        return Semester(
          id: sem['semester_id']?.toString() ?? 'unknown_semester',
          name: sem['semester_name']?.toString() ?? 'فصل دراسي',
          subjects: (sem['subjects'] as List? ?? [])
              .map((subJson) => _parseSubject(subJson))
              .toList(),
        );
      })
      .toList();

  return Stage(
    id: json['level_id']?.toString() ?? 'unknown_level',
    name: json['level_name']?.toString() ?? 'غير معروف',
    semesters: semesters,
  );
}
  
  
 Subject _parseSubject(Map<String, dynamic> json) {
  return Subject(
    id: json['subject_id']?.toString() ?? 'unknown_subject',
    name: json['subject_name']?.toString() ?? 'غير معروف',
    icon: _subjectIcon(json['category']?.toString()),
    description: json['category']?.toString() ?? '',
    units: (json['units'] as List? ?? [])
        .map((u) => _parseUnit(u))
        .toList(),
  );
}
  
  Unit _parseUnit(Map<String, dynamic> json) {
    return Unit(
      id:
          json['unit_id']?.toString() ??
          json['id']?.toString() ??
          'unknown_unit',
      name:
          json['unit_title']?.toString() ??
          json['name']?.toString() ??
          'الوحدة',
      description: json['unit_title']?.toString(),
      lessons: (json['lessons'] as List? ?? [])
          .map((lessonJson) => _parseLesson(lessonJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Lesson _parseLesson(Map<String, dynamic> json) {
    return Lesson(
      id:
          json['lesson_id']?.toString() ??
          json['id']?.toString() ??
          'unknown_lesson',
      name:
          json['lesson_title']?.toString() ??
          json['name']?.toString() ??
          'الدرس',
      content: json['summary']?.toString() ?? json['content']?.toString() ?? '',
      keyPoints: (json['key_terms'] as List?)
          ?.map((item) => item.toString())
          .toList(),
    );
  }

  String _subjectIcon(String? category) {
    if (category == null) return '📚';
    final normalized = category.toLowerCase();
    if (normalized.contains('رياضيات')) return '➗';
    if (normalized.contains('اللغة العربية') || normalized.contains('العربية'))
      return '✍️';
    if (normalized.contains('الإسلامية') ||
        normalized.contains('التربية الإسلامية'))
      return '🕌';
    if (normalized.contains('القرآن')) return '📖';
    if (normalized.contains('التجويد')) return '🎤';
    if (normalized.contains('التفسير')) return '🔍';
    return '📘';
  }

  /// Get all stages
  List<Stage> getAllStages() => _stages.values.toList();

  /// Get stage by ID
  Stage? getStage(String stageId) => _stages[stageId];

  /// Get subjects for a stage
List<Subject> getSubjectsForStage(String stageId) {
  final stage = _stages[stageId];
  if (stage == null) return [];

  return stage.semesters
      .expand((sem) => sem.subjects)
      .toList();
}List<Semester> getSemestersForStage(String stageId) {
  return _stages[stageId]?.semesters ?? [];
}

List<Subject> getSubjectsForSemester(String stageId, String semesterId) {
  final stage = _stages[stageId];
  if (stage == null) return [];

  final semester = stage.semesters.firstWhere(
    (s) => s.id == semesterId,
    orElse: () => stage.semesters.first,
  );

  return semester.subjects;
}
  /// Get semesters for a subject
  /// Get units for a semester
  List<Unit> getUnits(
  String stageId,
  String semesterId,
  String subjectId,
) {
  final subjects = getSubjectsForSemester(stageId, semesterId);

  final subject = subjects.firstWhere(
    (s) => s.id == subjectId,
    orElse: () => subjects.first,
  );

  return subject.units;
}

  /// Get lessons for a unit
 List<Lesson> getLessons(
  String stageId,
  String semesterId,
  String subjectId,
  String unitId,
) {
  final units = getUnits(stageId, semesterId, subjectId);

  final unit = units.firstWhere(
    (u) => u.id == unitId,
    orElse: () => units.first,
  );

  return unit.lessons;
}
  /// Get all lessons for a unit (for quiz generation)
  List<Lesson> getAllLessonsForUnit(
    String stageId,
    String subjectId,
    String semesterId,
    String unitId,
  ) {
    return getLessons(stageId, semesterId, subjectId, unitId) ?? [];
  }

  /// Generate quiz context from curriculum path
  String generateQuizContext(
  String stageId,
  String semesterId,
  String subjectId,
  String unitId,
) {
  final stage = _stages[stageId];
  if (stage == null) return '';

  // ✅ نجيب الفصل مباشرة من المرحلة
  final semester = stage.semesters.firstWhere(
    (s) => s.id == semesterId,
    orElse: () => stage.semesters.first,
  );

  // ✅ نجيب المادة من داخل الفصل
  final subject = semester.subjects.firstWhere(
    (s) => s.id == subjectId,
    orElse: () => semester.subjects.first,
  );

  // ✅ نجيب الوحدة من داخل المادة
  final unit = subject.units.firstWhere(
    (u) => u.id == unitId,
    orElse: () => subject.units.first,
  );

  return '''
Stage: ${stage.name}
Semester: ${semester.name}
Subject: ${subject.name}
Unit: ${unit.name}
Description: ${unit.description ?? 'No description'}
Key Topics: ${unit.lessons.map((l) => l.name).join(', ')}
''';
}
  /// Get curriculum statistics
 Map<String, dynamic> getCurriculumStats() {
  int totalStages = _stages.length;

  int totalSemesters = _stages.values.fold(
    0,
    (sum, stage) => sum + stage.semesters.length,
  );

  int totalSubjects = _stages.values.fold(
    0,
    (sum, stage) =>
        sum +
        stage.semesters.fold(
          0,
          (semSum, semester) => semSum + semester.subjects.length,
        ),
  );

  int totalUnits = _stages.values.fold(
    0,
    (sum, stage) =>
        sum +
        stage.semesters.fold(
          0,
          (semSum, semester) =>
              semSum +
              semester.subjects.fold(
                0,
                (subSum, subject) => subSum + subject.units.length,
              ),
        ),
  );

  int totalLessons = _stages.values.fold(
    0,
    (sum, stage) =>
        sum +
        stage.semesters.fold(
          0,
          (semSum, semester) =>
              semSum +
              semester.subjects.fold(
                0,
                (subSum, subject) =>
                    subSum +
                    subject.units.fold(
                      0,
                      (unitSum, unit) =>
                          unitSum + unit.lessons.length,
                    ),
              ),
        ),
  );

  return {
    'totalStages': totalStages,
    'totalSemesters': totalSemesters,
    'totalSubjects': totalSubjects,
    'totalUnits': totalUnits,
    'totalLessons': totalLessons,
  };
}}
