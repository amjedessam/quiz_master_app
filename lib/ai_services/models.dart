/// Data models for AI services

// Educational Curriculum Models
class Stage {
  final String id;
  final String name; // e.g., "المرحلة الابتدائية"
  final List<Semester> semesters;

  Stage({
    required this.id,
    required this.name,
    required this.semesters,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'],
      name: json['name'],
      semesters: (json['semesters'] as List)
          .map((s) => Semester.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'semesters': semesters.map((s) => s.toJson()).toList(),
    };
  }
}
class Semester {
  final String id;
  final String name; // e.g., "الفصل الدراسي الأول"
  final List<Subject> subjects;

  Semester({
    required this.id,
    required this.name,
    required this.subjects,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      name: json['name'],
      subjects: (json['subjects'] as List).map((s) => Subject.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((s) => s.toJson()).toList(),
    };
  }
}

class Subject {
  final String id;
  final String name; // e.g., "الرياضيات"
  final String icon;
  final String description;
  final List<Unit> units;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.units,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? '📚',
      description: json['description'] ?? '',
      units: (json['units'] as List)
          .map((u) => Unit.fromJson(u))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'units': units.map((u) => u.toJson()).toList(),
    };
  }
}


class Unit {
  final String id;
  final String name; // e.g., "الوحدة الأولى: الأعداد"
  final List<Lesson> lessons;
  final String? description;

  Unit({
    required this.id,
    required this.name,
    required this.lessons,
    this.description,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'],
      lessons: (json['lessons'] as List).map((l) => Lesson.fromJson(l)).toList(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'description': description,
    };
  }
}

class Lesson {
  final String id;
  final String name;
  final String? content;
  final List<String>? keyPoints;

  Lesson({
    required this.id,
    required this.name,
    this.content,
    this.keyPoints,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      keyPoints: json['keyPoints'] != null ? List<String>.from(json['keyPoints']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'keyPoints': keyPoints,
    };
  }
}

// Question Types Models
class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class Quiz {
  final String title;
  final List<Question> questions;

  Quiz({
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      title: json['title'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

// Enhanced Question Types
class TrueFalseQuestion {
  final String text;
  final bool correctAnswer;
  final String explanation;

  TrueFalseQuestion({
    required this.text,
    required this.correctAnswer,
    required this.explanation,
  });

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) {
    return TrueFalseQuestion(
      text: json['text'],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}

class FillInTheBlanksQuestion {
  final String text; // "The capital of France is ___"
  final List<String> correctAnswers; // Multiple acceptable answers
  final String explanation;

  FillInTheBlanksQuestion({
    required this.text,
    required this.correctAnswers,
    required this.explanation,
  });

  factory FillInTheBlanksQuestion.fromJson(Map<String, dynamic> json) {
    return FillInTheBlanksQuestion(
      text: json['text'],
      correctAnswers: List<String>.from(json['correctAnswers']),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'correctAnswers': correctAnswers,
      'explanation': explanation,
    };
  }
}

class MatchingQuestion {
  final String text;
  final List<String> leftItems;
  final List<String> rightItems;
  final Map<String, String> correctMatches; // {"left_item": "right_item"}
  final String explanation;

  MatchingQuestion({
    required this.text,
    required this.leftItems,
    required this.rightItems,
    required this.correctMatches,
    required this.explanation,
  });

  factory MatchingQuestion.fromJson(Map<String, dynamic> json) {
    return MatchingQuestion(
      text: json['text'],
      leftItems: List<String>.from(json['leftItems']),
      rightItems: List<String>.from(json['rightItems']),
      correctMatches: Map<String, String>.from(json['correctMatches']),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'leftItems': leftItems,
      'rightItems': rightItems,
      'correctMatches': correctMatches,
      'explanation': explanation,
    };
  }
}

class MultiSelectQuestion {
  final String text;
  final List<String> options;
  final List<String> correctAnswers; // Multiple correct answers
  final String explanation;

  MultiSelectQuestion({
    required this.text,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
  });

  factory MultiSelectQuestion.fromJson(Map<String, dynamic> json) {
    return MultiSelectQuestion(
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswers: List<String>.from(json['correctAnswers']),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options,
      'correctAnswers': correctAnswers,
      'explanation': explanation,
    };
  }
}

class ShortAnswerQuestion {
  final String text;
  final List<String> acceptableAnswers; // For grading/comparison
  final String explanation;

  ShortAnswerQuestion({
    required this.text,
    required this.acceptableAnswers,
    required this.explanation,
  });

  factory ShortAnswerQuestion.fromJson(Map<String, dynamic> json) {
    return ShortAnswerQuestion(
      text: json['text'],
      acceptableAnswers: List<String>.from(json['acceptableAnswers']),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'acceptableAnswers': acceptableAnswers,
      'explanation': explanation,
    };
  }
}

// Quiz Result Models
class QuizResult {
  final String quizId;
  final String studentId;
  final DateTime completedAt;
  final int totalQuestions;
  final int correctAnswers;
  final String explanation;
  final Duration timeTaken;
  final List<QuestionResult> results;

  QuizResult({
    required this.quizId,
    required this.studentId,
    required this.completedAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.explanation,
    required this.timeTaken,
    required this.results,
  });

  double get score => (correctAnswers / totalQuestions) * 100;

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'],
      studentId: json['studentId'],
      completedAt: DateTime.parse(json['completedAt']),
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      explanation: json['explanation'] ?? '',
      timeTaken: Duration(milliseconds: json['timeTaken']),
      results: (json['results'] as List).map((r) => QuestionResult.fromJson(r)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'studentId': studentId,
      'completedAt': completedAt.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeTaken': timeTaken.inMilliseconds,
      'results': results.map((r) => r.toJson()).toList(),
    };
  }
}

class QuestionResult {
  final String questionId;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;
  final bool isCorrect;
  final Duration timeSpent;

  QuestionResult({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
    required this.isCorrect,
    required this.timeSpent,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'],
      userAnswer: json['userAnswer'],
      correctAnswer: json['correctAnswer'] ?? '',
      explanation: json['explanation'] ?? '',
      isCorrect: json['isCorrect'],
      timeSpent: Duration(milliseconds: json['timeSpent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent.inMilliseconds,
    };
  }
}

class DataAnalysis {
  final String summary;
  final Map<String, dynamic> insights;

  DataAnalysis({
    required this.summary,
    required this.insights,
  });

  factory DataAnalysis.fromJson(Map<String, dynamic> json) {
    return DataAnalysis(
      summary: json['summary'],
      insights: json['insights'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'insights': insights,
    };
  }
}