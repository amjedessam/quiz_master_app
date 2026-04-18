
import 'dart:convert';
import 'package:dio/dio.dart';
import 'config.dart';
import 'models.dart';

/// مولد أسئلة متقدم مع أنواع أسئلة متنوعة لتعزيز تجربة المستخدم
class EnhancedQuestionGenerator {

   final Dio _dio = Dio();
   int aimodel = 0; // 0 for Gemini, 1 for OpenAI, 2 for Ollama

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
2. صح أم خطأ (40%): أسئلة بسيطة للإجابة بصح أو خطأ.
3. أكمل الفراغات (10%): أسئلة لإكمال الجملة.
4. إجابة قصيرة (10%): أسئلة تتطلب إجابة موجزة.

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

   // final content = _extractJson(response.data['message']['content']);y
   final response = await AIChat().getAIResponse(prompt, aimodel);
   final questionsJson = _decodeAIResponse(response);

   if (questionsJson is! Map<String, dynamic>) {
     throw Exception('Expected JSON object with question groups, got ${questionsJson.runtimeType}');
   }

   return {
     'multipleChoice': (questionsJson['multipleChoice'] as List? ?? [])
         .map((q) => Question.fromJson(q)).toList(),
  'trueFalse': (questionsJson['trueFalse'] as List? ?? [])
      .map((q) => TrueFalseQuestion.fromJson(q)).toList(),
  'fillInBlanks': (questionsJson['fillInBlanks'] as List? ?? [])
      .map((q) => FillInTheBlanksQuestion.fromJson(q)).toList(),
  'shortAnswer': (questionsJson['shortAnswer'] as List? ?? [])
      .map((q) => ShortAnswerQuestion.fromJson(q)).toList(),
      
  // ... وبقية الأنواع بنفس الطريقة
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

    String response = await AIChat().getAIResponse(prompt, aimodel);
    final questionsJson = _decodeAIResponse(response);

    if (questionsJson is! List) {
      throw Exception('Expected JSON list for multiple choice questions, got ${questionsJson.runtimeType}');
    }

    return questionsJson.map((q) => Question.fromJson(q)).toList();
  }

  /// توليد أسئلة صح أم خطأ
  Future<List<TrueFalseQuestion>> generateTrueFalse(String topic, int count) async {
    final prompt = '''
قم بإنشاء $count أسئلة صح أم خطأ حول "$topic".
التنسيق: مصفوفة JSON من الكائنات بالمفاتيح: text, correctAnswer (boolean), explanation.
اللغة: العربية.
''';

    String response = await AIChat().getAIResponse(prompt, aimodel);
    final questionsJson = _decodeAIResponse(response);

    if (questionsJson is! List) {
      throw Exception('Expected JSON list for true/false questions, got ${questionsJson.runtimeType}');
    }

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

    String response = await AIChat().getAIResponse(prompt, aimodel);
    final questionsJson = _decodeAIResponse(response);

    if (questionsJson is! List) {
      throw Exception('Expected JSON list for fill-in-the-blanks questions, got ${questionsJson.runtimeType}');
    }

    return questionsJson.map((q) => FillInTheBlanksQuestion.fromJson(q)).toList();
  }

  dynamic _decodeAIResponse(String response) {
    if (response.startsWith('Error from Server:') || response.startsWith('Exception:')) {
      final errorBodyStart = response.indexOf('{');
      if (errorBodyStart != -1) {
        final errorJson = response.substring(errorBodyStart);
        try {
          final decoded = jsonDecode(errorJson);
          if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
            final error = decoded['error'];
            final message = error is Map<String, dynamic>
                ? error['message'] ?? error.toString()
                : error.toString();
            throw Exception('AI API error: $message');
          }
        } catch (_) {
          throw Exception(response);
        }
      }
      throw Exception(response);
    }

    final cleanJson = _extractJson(response);
    try {
      final decoded = jsonDecode(cleanJson);
      if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
        final error = decoded['error'];
        final message = error is Map<String, dynamic>
            ? error['message'] ?? error.toString()
            : error.toString();
        throw Exception('AI API error: $message');
      }
      return decoded;
    } on FormatException catch (e) {
      throw Exception('Unable to decode AI response as JSON: ${e.message}\nResponse: $response');
    }
  }

  /// دالة مساعدة لاستخراج الـ JSON من ردود Ollama
  String _extractJson(String text) {
  try {
    // البحث عن بداية ونهاية الـ JSON الحقيقية
    int startIndex = text.indexOf('{');
    int endIndex = text.lastIndexOf('}');
    
    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex + 1);
    }
  } catch (e) {
    print("Extraction Error: $e");
  }
  return text.trim();
}
}