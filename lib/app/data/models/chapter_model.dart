class ChapterModel {
  final String id;
  final String subjectId;
  final String name;
  final int order;
  final int questionsCount;
  final double progress;
  final bool isCompleted;

  ChapterModel({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.order,
    required this.questionsCount,
    required this.progress,
    required this.isCompleted,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id']?.toString() ?? '',
      subjectId: json['subject_id']?.toString() ?? json['subjectId']?.toString() ?? '',
      name: json['name'] ?? '',
      order: (json['order'] ?? json['order_index']) as int? ?? 0,
      questionsCount: (json['questions_count'] ?? json['questionsCount']) as int? ?? 0,
      progress: _toDouble(json['progress']),
      isCompleted: (json['is_completed'] ?? json['isCompleted']) as bool? ?? false,
    );
  }

  /// From Supabase get_chapters_with_progress
  factory ChapterModel.fromSupabase(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id']?.toString() ?? '',
      subjectId: json['subject_id']?.toString() ?? '',
      name: json['name'] ?? '',
      order: (json['order_index']) as int? ?? 0,
      questionsCount: (json['questions_count'] is int)
          ? json['questions_count'] as int
          : (json['questions_count'] as num?)?.toInt() ?? 0,
      progress: _toDouble(json['progress']),
      isCompleted: (json['is_completed']) as bool? ?? false,
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
