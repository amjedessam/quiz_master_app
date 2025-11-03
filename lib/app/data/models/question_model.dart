class QuestionModel {
  final String id;
  final String content;
  final String type;
  final Map<String, String> options;
  final String correctAnswer;
  final String explanation;
  final String difficulty;
  final String skill;
  final String? referencePage;

  QuestionModel({
    required this.id,
    required this.content,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
    required this.skill,
    this.referencePage,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      content: json['content'],
      type: json['type'],
      options: Map<String, String>.from(json['options']),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'],
      difficulty: json['difficulty'],
      skill: json['skill'],
      referencePage: json['reference_page'],
    );
  }
}
