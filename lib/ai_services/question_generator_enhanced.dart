// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'config.dart';
// import 'models.dart';

// /// Enhanced question generator with variety of question types
// class EnhancedQuestionGenerator {
//   final Dio _dio = Dio();

//   EnhancedQuestionGenerator() {
//     _dio.options.headers = {
//       'Authorization': 'Bearer ${AIConfig.openAIKey}',
//       'Content-Type': 'application/json',
//     };
//   }

//   /// Generate varied questions with different types for better user experience
//   Future<Map<String, dynamic>> generateVariedQuestions(
//     String topic,
//     String context,
//     int totalCount,
//   ) async {
//     final prompt = '''
// Generate $totalCount diverse educational questions about "$topic" for students.
// Context: $context

// Create a mix of different question types:
// 1. Multiple Choice Questions (40%): 4 options with one correct answer
// 2. True/False Questions (20%): Simple true/false questions
// 3. Fill in the Blanks (20%): Complete the sentence questions
// 4. Short Answer (20%): Brief answer questions

// Return as JSON with this structure:
// {
//   "multipleChoice": [
//     {
//       "text": "question text",
//       "options": ["option1", "option2", "option3", "option4"],
//       "correctAnswer": "option text",
//       "explanation": "why this is correct"
//     }
//   ],
//   "trueFalse": [
//     {
//       "text": "statement",
//       "correctAnswer": true/false,
//       "explanation": "explanation"
//     }
//   ],
//   "fillInBlanks": [
//     {
//       "text": "sentence with ___",
//       "correctAnswers": ["answer1", "answer2"],
//       "explanation": "explanation"
//     }
//   ],
//   "shortAnswer": [
//     {
//       "text": "question",
//       "acceptableAnswers": ["answer1", "answer2"],
//       "explanation": "explanation"
//     }
//   ]
// }
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 3000,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content);
    
//     return {
//       'multipleChoice': (questionsJson['multipleChoice'] as List)
//           .map((q) => Question.fromJson(q))
//           .toList(),
//       'trueFalse': (questionsJson['trueFalse'] as List)
//           .map((q) => TrueFalseQuestion.fromJson(q))
//           .toList(),
//       'fillInBlanks': (questionsJson['fillInBlanks'] as List)
//           .map((q) => FillInTheBlanksQuestion.fromJson(q))
//           .toList(),
//       'shortAnswer': (questionsJson['shortAnswer'] as List)
//           .map((q) => ShortAnswerQuestion.fromJson(q))
//           .toList(),
//     };
//   }

//   /// Generate multiple choice questions only
//   Future<List<Question>> generateMultipleChoice(String topic, int count) async {
//     final prompt = '''
// Generate $count multiple-choice questions about "$topic".
// Each question should have exactly 4 options, one correct answer, and a brief explanation.
// Format as JSON array of objects with keys: text, options (array), correctAnswer, explanation.
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 2000,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content) as List;
//     return questionsJson.map((q) => Question.fromJson(q)).toList();
//   }

//   /// Generate true/false questions
//   Future<List<TrueFalseQuestion>> generateTrueFalse(String topic, int count) async {
//     final prompt = '''
// Generate $count true/false questions about "$topic".
// Format as JSON array of objects with keys: text, correctAnswer (boolean), explanation.
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 1500,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content) as List;
//     return questionsJson.map((q) => TrueFalseQuestion.fromJson(q)).toList();
//   }

//   /// Generate fill in the blanks questions
//   Future<List<FillInTheBlanksQuestion>> generateFillInBlanks(String topic, int count) async {
//     final prompt = '''
// Generate $count fill-in-the-blanks questions about "$topic".
// Use ___ to indicate blank spaces.
// Format as JSON array with keys: text, correctAnswers (array), explanation.
// Include multiple acceptable answers where applicable.
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 1500,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content) as List;
//     return questionsJson.map((q) => FillInTheBlanksQuestion.fromJson(q)).toList();
//   }

//   /// Generate multi-select questions
//   Future<List<MultiSelectQuestion>> generateMultiSelect(String topic, int count) async {
//     final prompt = '''
// Generate $count multi-select questions about "$topic".
// Each question should have 4-5 options with 2-3 correct answers.
// Format as JSON array with keys: text, options (array), correctAnswers (array), explanation.
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 1500,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content) as List;
//     return questionsJson.map((q) => MultiSelectQuestion.fromJson(q)).toList();
//   }

//   /// Generate short answer questions
//   Future<List<ShortAnswerQuestion>> generateShortAnswer(String topic, int count) async {
//     final prompt = '''
// Generate $count short answer questions about "$topic".
// Each question should be answered in 1-3 sentences.
// Format as JSON array with keys: text, acceptableAnswers (array), explanation.
// Include multiple acceptable answer variations.
// ''';

//     final response = await _dio.post(
//       AIConfig.openAIUrl,
//       data: {
//         'model': AIConfig.model,
//         'messages': [
//           {'role': 'user', 'content': prompt}
//         ],
//         'max_tokens': 1500,
//       },
//     );

//     final content = response.data['choices'][0]['message']['content'];
//     final questionsJson = jsonDecode(content) as List;
//     return questionsJson.map((q) => ShortAnswerQuestion.fromJson(q)).toList();
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'config.dart';
import 'models.dart';

/// مولد أسئلة متقدم مع أنواع أسئلة متنوعة لتعزيز تجربة المستخدم
class EnhancedQuestionGenerator {
  final Dio _dio = Dio();

  EnhancedQuestionGenerator() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  /// توليد أسئلة متنوعة بناءً على الموضوع والسياق المقدم
  Future<Map<String, dynamic>> generateVariedQuestions(
    String topic,
    String context,
    int totalCount,
  ) async {
    final prompt = '''
قم بتوليد $totalCount سؤالاً تعليمياً متنوعاً حول موضوع: "$topic" للطلاب.
السياق المرجعي: $context

قم بإنشاء مزيج من أنواع الأسئلة التالية:
1. اختيار من متعدد (40%): 4 خيارات مع إجابة صحيحة واحدة.
2. صح أم خطأ (20%): أسئلة بسيطة للإجابة بصح أو خطأ.
3. أكمل الفراغات (20%): أسئلة لإكمال الجملة.
4. إجابة قصيرة (20%): أسئلة تتطلب إجابة موجزة.

يجب أن يكون الرد بصيغة JSON فقط بالهيكل التالي:
{
  "multipleChoice": [
    {
      "text": "نص السؤال",
      "options": ["خيار1", "خيار2", "خيار3", "خيار4"],
      "correctAnswer": "نص الإجابة الصحيحة",
      "explanation": "شرح لماذا هذه الإجابة صحيحة"
    }
  ],
  "trueFalse": [
    {
      "text": "العبارة",
      "correctAnswer": true/false,
      "explanation": "التوضيح"
    }
  ],
  "fillInBlanks": [
  {
    "text": "الجملة مع استخدام علامة (____) للفراغ، وتجنب استخدام أي علامات تنصيص داخل النص",
    "correctAnswers": ["إجابة1"],
    "explanation": "التوضيح"
  }
],
  "shortAnswer": [
    {
      "text": "السؤال",
      "acceptableAnswers": ["إجابة1", "إجابة2"],
      "explanation": "التوضيح"
    }
  ]
}
ملاحظة: تأكد أن تكون جميع النصوص باللغة العربية، مع الحفاظ على أسماء المفاتيح (Keys) بالإنجليزية.
''';

    final response = await _dio.post(
      AIConfig.ollamaUrl,
      data: {
        'model': AIConfig.ollamaModel,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'stream': false,
      },
    );

    final content = _extractJson(response.data['message']['content']);
    final questionsJson = jsonDecode(content);
    
    return {
      'multipleChoice': (questionsJson['multipleChoice'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      'trueFalse': (questionsJson['trueFalse'] as List)
          .map((q) => TrueFalseQuestion.fromJson(q))
          .toList(),
      'fillInBlanks': (questionsJson['fillInBlanks'] as List)
          .map((q) => FillInTheBlanksQuestion.fromJson(q))
          .toList(),
      'shortAnswer': (questionsJson['shortAnswer'] as List)
          .map((q) => ShortAnswerQuestion.fromJson(q))
          .toList(),
    };
  }

  /// توليد أسئلة اختيار من متعدد فقط
  Future<List<Question>> generateMultipleChoice(String topic, int count) async {
    final prompt = '''
قم بتوليد $count أسئلة اختيار من متعدد حول موضوع: "$topic".
كل سؤال يجب أن يحتوي على 4 خيارات بالضبط، إجابة صحيحة واحدة، وشرح موجز.
التنسيق: مصفوفة JSON من الكائنات بالمفاتيح: text, options (array), correctAnswer, explanation.
اللغة: العربية.
''';

    final response = await _dio.post(
      AIConfig.ollamaUrl,
      data: {
        'model': AIConfig.ollamaModel,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'stream': false,
      },
    );

    final content = _extractJson(response.data['message']['content']);
    final questionsJson = jsonDecode(content) as List;
    return questionsJson.map((q) => Question.fromJson(q)).toList();
  }

  /// توليد أسئلة صح أم خطأ
  Future<List<TrueFalseQuestion>> generateTrueFalse(String topic, int count) async {
    final prompt = '''
قم بإنشاء $count أسئلة صح أم خطأ حول "$topic".
التنسيق: مصفوفة JSON من الكائنات بالمفاتيح: text, correctAnswer (boolean), explanation.
اللغة: العربية.
''';

    final response = await _dio.post(
      AIConfig.ollamaUrl,
      data: {
        'model': AIConfig.ollamaModel,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'stream': false,
      },
    );

    final content = _extractJson(response.data['message']['content']);
    final questionsJson = jsonDecode(content) as List;
    return questionsJson.map((q) => TrueFalseQuestion.fromJson(q)).toList();
  }

  /// توليد أسئلة أكمل الفراغات
  Future<List<FillInTheBlanksQuestion>> generateFillInBlanks(String topic, int count) async {
    final prompt = '''
قم بتوليد $count أسئلة أكمل الفراغات حول موضوع: "$topic".
استخدم ___ للإشارة إلى الفراغ.
التنسيق: مصفوفة JSON بالمفاتيح: text, correctAnswers (array), explanation.
اللغة: العربية.
''';

    final response = await _dio.post(
      AIConfig.ollamaUrl,
      data: {
        'model': AIConfig.ollamaModel,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'stream': false,
      },
    );

    final content = _extractJson(response.data['message']['content']);
    final questionsJson = jsonDecode(content) as List;
    return questionsJson.map((q) => FillInTheBlanksQuestion.fromJson(q)).toList();
  }

  /// دالة مساعدة لاستخراج الـ JSON من ردود Ollama
  String _extractJson(String text) {
    if (text.contains('```json')) {
      return text.split('```json')[1].split('```')[0].trim();
    } else if (text.contains('```')) {
      return text.split('```')[1].split('```')[0].trim();
    }
    return text.trim();
  }
}