class ResultModel {
  final String id;
  final String quizId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int unanswered;
  final int timeTaken;
  final DateTime completedAt;
  final Map<String, double> masteryBySkill;
  final double percentage;

  ResultModel({
    required this.id,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unanswered,
    required this.timeTaken,
    required this.completedAt,
    required this.masteryBySkill,
  }) : percentage = (score / totalQuestions * 100);
}
