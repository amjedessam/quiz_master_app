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
      id: json['id'],
      subjectId: json['subject_id'],
      name: json['name'],
      order: json['order'],
      questionsCount: json['questions_count'],
      progress: json['progress'].toDouble(),
      isCompleted: json['is_completed'],
    );
  }
}
