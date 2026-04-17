/// Example usage of AI Services
/// This shows how to use the AI service in your app.

import 'ai_services.dart';

// Define a custom question model
class CustomQuestion {
  final String questionText;
  final List<String> choices;

  CustomQuestion({required this.questionText, required this.choices});

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      questionText: json['questionText'],
      choices: List<String>.from(json['choices']),
    );
  }
}

void main() async {
  final aiService = AIService();

  // Generate questions using Question model
  final questions = await aiService.generateQuestions<Question>('Flutter Development', 5, Question.fromJson);
  print('Generated ${questions.length} questions');

  // Generate questions using custom model
  final customQuestions = await aiService.generateQuestions<CustomQuestion>(
    'Dart Programming',
    3,
    CustomQuestion.fromJson,
  );
  print('Generated ${customQuestions.length} custom questions');

  // Generate a quiz
  final quiz = await aiService.generateQuiz('Dart Programming', 10);
  print('Quiz: ${quiz.title} with ${quiz.questions.length} questions');

  // Analyze data
  final data = {'scores': [85, 90, 78, 92, 88]};
  final analysis = await aiService.analyzeData(data);
  print('Analysis: ${analysis.summary}');
}