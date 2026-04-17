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
    final subjects = (json['subjects'] as List? ?? [])
        .map(
          (subjectJson) => _parseSubject(subjectJson as Map<String, dynamic>),
        )
        .toList();

    return Stage(
      id:
          json['level_id']?.toString() ??
          json['id']?.toString() ??
          'unknown_level',
      name:
          json['level_name']?.toString() ??
          json['name']?.toString() ??
          'غير معروف',
      subjects: subjects,
    );
  }

  Subject _parseSubject(Map<String, dynamic> json) {
    final part = json['part']?.toString() ?? '1';
    final semesterId = '${json['subject_id'] ?? json['id']}_part_$part';
    final semesterName = 'الجزء $part';

    return Subject(
      id:
          json['subject_id']?.toString() ??
          json['id']?.toString() ??
          'unknown_subject',
      name:
          json['subject_name']?.toString() ??
          json['name']?.toString() ??
          'غير معروف',
      icon: _subjectIcon(json['category']?.toString()),
      description: json['category']?.toString() ?? '',
      semesters: [
        Semester(
          id: semesterId,
          name: semesterName,
          units: (json['units'] as List? ?? [])
              .map((unitJson) => _parseUnit(unitJson as Map<String, dynamic>))
              .toList(),
        ),
      ],
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
  List<Subject>? getSubjectsForStage(String stageId) {
    return _stages[stageId]?.subjects;
  }

  /// Get semesters for a subject
  List<Semester>? getSemestersForSubject(String stageId, String subjectId) {
    final stage = _stages[stageId];
    if (stage == null) return null;

    final subject = stage.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => stage.subjects.first,
    );
    return subject.semesters;
  }

  /// Get units for a semester
  List<Unit>? getUnitsForSemester(
    String stageId,
    String subjectId,
    String semesterId,
  ) {
    final stage = _stages[stageId];
    if (stage == null) return null;

    final subject = stage.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => stage.subjects.first,
    );

    final semester = subject.semesters.firstWhere(
      (sem) => sem.id == semesterId,
      orElse: () => subject.semesters.first,
    );

    return semester.units;
  }

  /// Get lessons for a unit
  List<Lesson>? getLessonsForUnit(
    String stageId,
    String subjectId,
    String semesterId,
    String unitId,
  ) {
    final units = getUnitsForSemester(stageId, subjectId, semesterId);
    if (units == null) return null;

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
    return getLessonsForUnit(stageId, subjectId, semesterId, unitId) ?? [];
  }

  /// Generate quiz context from curriculum path
  String generateQuizContext(
    String stageId,
    String subjectId,
    String semesterId,
    String unitId,
  ) {
    final stage = _stages[stageId];
    if (stage == null) return '';

    final subject = stage.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => stage.subjects.first,
    );
    final semester = subject.semesters.firstWhere(
      (sem) => sem.id == semesterId,
      orElse: () => subject.semesters.first,
    );
    final units = semester.units;
    final unit = units.firstWhere(
      (u) => u.id == unitId,
      orElse: () => units.first,
    );

    return '''
Stage: ${stage.name}
Subject: ${subject.name}
Semester: ${semester.name}
Unit: ${unit.name}
Description: ${unit.description ?? 'No description'}
Key Topics: ${unit.lessons.map((l) => l.name).join(', ')}
''';
  }

  /// Get curriculum statistics
  Map<String, dynamic> getCurriculumStats() {
    int totalStages = _stages.length;
    int totalSubjects = _stages.values.fold(
      0,
      (sum, stage) => sum + stage.subjects.length,
    );
    int totalSemesters = _stages.values.fold(
      0,
      (sum, stage) =>
          sum +
          stage.subjects.fold(
            0,
            (subSum, subject) => subSum + subject.semesters.length,
          ),
    );
    int totalUnits = _stages.values.fold(
      0,
      (sum, stage) =>
          sum +
          stage.subjects.fold(
            0,
            (subSum, subject) =>
                subSum +
                subject.semesters.fold(
                  0,
                  (semSum, semester) => semSum + semester.units.length,
                ),
          ),
    );
    int totalLessons = _stages.values.fold(
      0,
      (sum, stage) =>
          sum +
          stage.subjects.fold(
            0,
            (subSum, subject) =>
                subSum +
                subject.semesters.fold(
                  0,
                  (semSum, semester) =>
                      semSum +
                      semester.units.fold(
                        0,
                        (uSum, unit) => uSum + unit.lessons.length,
                      ),
                ),
          ),
    );

    return {
      'totalStages': totalStages,
      'totalSubjects': totalSubjects,
      'totalSemesters': totalSemesters,
      'totalUnits': totalUnits,
      'totalLessons': totalLessons,
    };
  }
}
