class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int chaptersCount;
  final double progress;
  final int totalQuizzes;
  final double averageScore;

  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.chaptersCount,
    required this.progress,
    required this.totalQuizzes,
    required this.averageScore,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      chaptersCount: json['chapters_count'],
      progress: json['progress'].toDouble(),
      totalQuizzes: json['total_quizzes'],
      averageScore: json['average_score'].toDouble(),
    );
  }
}
