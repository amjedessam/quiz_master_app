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
  final String? pdfUrl; // ← جديد

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
    this.pdfUrl, // ← جديد
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '📚',
      color: json['color'] ?? '0xFF6C63FF',
      chaptersCount:
          (json['chapters_count'] ?? json['chaptersCount']) as int? ?? 0,
      progress: _toDouble(json['progress']),
      totalQuizzes:
          (json['total_quizzes'] ?? json['totalQuizzes']) as int? ?? 0,
      averageScore: _toDouble(json['average_score'] ?? json['averageScore']),
      pdfUrl: json['pdf_url'], // ← جديد
    );
  }

  factory SubjectModel.fromSupabase(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '📚',
      color: json['color'] ?? '0xFF6C63FF',
      chaptersCount: (json['chapters_count']) as int? ?? 0,
      progress: _toDouble(json['progress']),
      totalQuizzes: (json['total_quizzes']) as int? ?? 0,
      averageScore: _toDouble(json['average_score']),
      pdfUrl: json['pdf_url'], // ← جديد
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
