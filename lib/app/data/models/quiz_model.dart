import 'question_model.dart';

class QuizModel {
  final String id;
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterName;
  final List<QuestionModel> questions;
  final DateTime createdAt;
  final int? timeLimit;

  QuizModel({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterName,
    required this.questions,
    required this.createdAt,
    this.timeLimit,
  });
}
