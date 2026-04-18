


import 'dart:convert';
import 'package:dio/dio.dart';
import 'config.dart';
import 'models.dart';

class AIService {
  final Dio _dio = Dio();

  AIService() {
    _dio.options.headers = {
      // في Ollama المحلي غالباً لا نحتاج لـ Authorization 
      // ولكن تركناها بصيغة عامة في حال أضفت حماية لاحقاً
      'Content-Type': 'application/json',
    };
  }

  /// توليد أسئلة بناءً على الموضوع
  Future<List<T>> generateQuestions<T>(
    String topic,
    int count,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    // تم تحويل البرومبت للعربية مع توجيه صارم للموديل بالالتزام بصيغة JSON
    final prompt = '''
قم بإنشاء $count أسئلة اختيار من متعدد حول موضوع: "$topic".
يجب أن يحتوي كل سؤال على 4 خيارات، إجابة صحيحة واحدة، وشرح موجز.
يجب أن يكون الرد بصيغة JSON فقط كصفوف (Array) من الكائنات (Objects) تحتوي على المفاتيح التالية:
text, options (array), correctAnswer, explanation.
تأكد أن تكون لغة الأسئلة هي العربية.
''';

    final response = await _dio.post(
      AIConfig.ollamaUrl, // استخدام رابط Ollama من الكلاس الجديد
      data: {
        'model': AIConfig.ollamaModel,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        'stream': false, // لضمان وصول JSON كامل للتحليل
      },
    );

    // في Ollama الرد يكون داخل ['message']['content'] وليس ['choices'][0]
    final String content = response.data['message']['content'];
    
    // تنظيف النص في حال أضاف الموديل كلمات خارج الـ JSON
    final cleanContent = _extractJson(content);
    
    final List questionsJson = jsonDecode(cleanContent);
    return questionsJson.map((q) => fromJson(q)).toList();
  }

  /// إنشاء اختبار كامل
  Future<Quiz> generateQuiz(String topic, int questionCount) async {
    final questions = await generateQuestions<Question>(topic, questionCount, Question.fromJson);
    return Quiz(title: 'اختبار حول: $topic', questions: questions);
  }

  /// تحليل البيانات (نتائج الاختبار مثلاً)
  Future<DataAnalysis> analyzeData(Map<String, dynamic> data) async {
    final prompt = '''
قم بتحليل البيانات التالية وقدم ملخصاً ورؤى أساسية:
${data.toString()}

نسق الرد بصيغة JSON مع المفاتيح التالية: summary, insights (كائن).
يجب أن يكون التحليل باللغة العربية.
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

    final String content = response.data['message']['content'];
    final analysisJson = jsonDecode(_extractJson(content));
    return DataAnalysis.fromJson(analysisJson);
  }

  /// دالة مساعدة لتنظيف مخرجات الذكاء الاصطناعي واستخراج الـ JSON فقط
 String _extractJson(String text) {
  // 1. استخراج النص الموجود بين علامات الكود إذا وجدت
  if (text.contains('```json')) {
    text = text.split('```json')[1].split('```')[0];
  } else if (text.contains('```')) {
    text = text.split('```')[1].split('```')[0];
  }
  
  // 2. تنظيف الرموز التي قد تسبب "Unrecognized string escape"
  // أحياناً الموديل يضيف مسافات أو رموز هروب غير صالحة (\)
  return text.trim();
}
}