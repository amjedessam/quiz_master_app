import 'dart:convert';

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
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? json['question_text'] ?? '',
      type: json['type'] ?? json['question_type'] ?? 'multiple_choice',
      options: _parseOptions(json['options'] ?? json['question_options']),
      correctAnswer: json['correct_answer']?.toString() ?? '',
      explanation: json['explanation'] ?? '',
      difficulty:
          json['difficulty'] ??
          json['difficulty_level']?.toString() ??
          'medium',
      skill: json['skill'] ?? 'apply',
      referencePage: json['reference_page'],
    );
  }

  static Map<String, String> _parseOptions(dynamic opts) {
    if (opts == null) return {};

    // إذا وصل كـ String من Supabase JSONB
    if (opts is String) {
      try {
        final decoded = jsonDecode(opts);
        if (decoded is Map) {
          return decoded.map(
            (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
          );
        }
      } catch (e) {
        print('❌ Options parse error: $e');
        return {};
      }
    }

    if (opts is Map<String, dynamic>) {
      return opts.map((k, v) => MapEntry(k, v?.toString() ?? ''));
    }

    if (opts is Map) {
      return opts.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
    }

    return {};
  }
}
