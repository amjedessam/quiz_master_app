// /// Configuration for AI services
// class AIConfig {
//   static const String openAIKey = 'AIzaSyDplYjgZpaHZ-Bv4f_FoeC8zI2qn6uJ4gs'; // Replace with your key
//   static const String openAIUrl = 'https://api.openai.com/v1/chat/completions';
//   static const String model = 'gpt-4'; // or gpt-3.5-turbo
// }
// class AIConfig {
//   
// }
import 'package:dio/dio.dart';

class AIConfig {
  static const String geminiKey = ''; // Replace with your key
  static const String geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';
  static const String geminiModel = 'gemini-2.0-flash'; 
  
  static const String openAiKey = ''; //ai apikey
  static const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String openAiModel = 'gpt-3.5-turbo'; // أو 'gpt-4o-mini' للسرعة والتوفير
  // استبدل 192.168.1.100 بـ عنوان الـ IP الخاص بجهاز الكمبيوتر في شبكتك
  
 
  // إذا كنت تستخدم محاكي الأندرويد الافتراضي، استخدم 10.0.2.2 بدلاً من IP الجهاز
  static const String ollamaUrl = 'http://192.168.1.100:11434/api/chat';
  // اسم النموذج الذي قمت بتحميله في Ollama
  static const String ollamaModel = 'qwen3.5:0.8b'; 
  // إعدادات إضافية للـ API المحلي
  static const bool useStream = false;
}


 class AIChat {
  final Dio _dio = Dio();

  Future<String> getAIResponse(String prompt, int modelType) async {
    String url = '';
    dynamic body;
    Options options = Options(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500, // يسمح بمرور الخطأ 400 لمعرفته بدلاً من الانهيار
    );

    try {
      if (modelType == 0) { // Gemini
        url = '${AIConfig.geminiUrl}?key=${AIConfig.geminiKey}';
        body = {
          "contents": [
            {
              "parts": [{"text": prompt}]
            }
          ]
        };
      } else if (modelType == 1) { // OpenAI
        url = AIConfig.openAiUrl;
        options.headers!['Authorization'] = 'Bearer ${AIConfig.openAiKey}';
        body = {
          'model': AIConfig.openAiModel,
          'messages': [{'role': 'user', 'content': prompt}],
        };
      } else if (modelType == 2) { // Ollama
        url = AIConfig.ollamaUrl;
        body = {
          'model': AIConfig.ollamaModel,
          'messages': [{'role': 'user', 'content': prompt}],
          'stream': false,
        };
      }

      final response = await _dio.post(url, data: body, options: options);

      // فحص إذا كان السيرفر أرجع خطأ 400 أو 404
      if (response.statusCode != 200) {
        return "Error from Server: ${response.statusCode} - ${response.data}";
      }

      // استخراج النص الصحيح بناءً على الموديل
      if (modelType == 0) { // Gemini
        return response.data['candidates'][0]['content']['parts'][0]['text'];
      } else if (modelType == 1) { // OpenAI
        return response.data['choices'][0]['message']['content'];
      } else if (modelType == 2) { // Ollama
        return response.data['message']['content'];
      }

      return "Unsupported Model";
    } catch (e) {
      return "Exception: $e";
    }
  }
}