// /// Configuration for AI services
// class AIConfig {
//   static const String openAIKey = 'AIzaSyDplYjgZpaHZ-Bv4f_FoeC8zI2qn6uJ4gs'; // Replace with your key
//   static const String openAIUrl = 'https://api.openai.com/v1/chat/completions';
//   static const String model = 'gpt-4'; // or gpt-3.5-turbo
// }
// class AIConfig {
//   
// }
class AIConfig {
  static const String openAIKey = 'AIzaSyDplYjgZpaHZ-Bv4f_FoeC8zI2qn6uJ4gs'; // Replace with your key
  static const String openAIUrl = 'https://aistudio.google.com/app/apikeys';
  static const String model = 'gemini-2.0-flash'; 
  // بما أنه سيرفر محلي، لا نحتاج لمفتاح API إلا إذا قمت بإعداد Proxy خاص
  static const String apiKey = ''; 
  
  // استبدل 192.168.1.100 بـ عنوان الـ IP الخاص بجهاز الكمبيوتر في شبكتك
  // إذا كنت تستخدم محاكي الأندرويد الافتراضي، استخدم 10.0.2.2 بدلاً من IP الجهاز
  static const String ollamaUrl = 'http://192.168.1.100:11434/api/chat';

  // اسم النموذج الذي قمت بتحميله في Ollama
  static const String ollamaModel = 'qwen3.5:0.8b'; 
  
  // إعدادات إضافية للـ API المحلي
  static const bool useStream = false;
}