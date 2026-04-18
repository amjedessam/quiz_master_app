/// Integration Example - كيفية دمج خدمة AI في التطبيق الرئيسي

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ai_services.dart';

void main() async {
  // Initialize AI Services
  await initializeAIServices();
  runApp(const MyApp());
}

Future<void> initializeAIServices() async {
  // Load curriculum from JSON (you can load from asset or API)
  final curriculumManager = CurriculumManager();
  
  // Load from asset
  final curriculumJson = await DefaultAssetBundle.of(Get.context!).loadString('lib/ai_services/sample_curriculum.json');
  await curriculumManager.loadCurriculumFromJson(curriculumJson);
  
  // Store in GetX for global access
  Get.put(curriculumManager);
  Get.put(EnhancedQuestionGenerator());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Master - الاختبارات التفاعلية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'اختر نوع الاختبار',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _startCurriculumBasedQuiz(context);
              },
              icon: const Icon(Icons.school),
              label: const Text('اختبار مبني على المنهج'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _startTopicBasedQuiz(context);
              },
              icon: const Icon(Icons.topic),
              label: const Text('اختبار مبني على موضوع'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startCurriculumBasedQuiz(BuildContext context) {
    final curriculumManager = Get.find<CurriculumManager>();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurriculumSelectionScreen(
          curriculumManager: curriculumManager,
          onUnitSelected: (stageId, subjectId, semesterId, unitId) {
            final questionGenerator = Get.find<EnhancedQuestionGenerator>();
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  stageId: stageId,
                  subjectId: subjectId,
                  semesterId: semesterId,
                  unitId: unitId,
                  curriculumManager: curriculumManager,
                  questionGenerator: questionGenerator,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _startTopicBasedQuiz(BuildContext context) async {
    // Get topic from user or predefined
    final topicController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('أدخل موضوع الاختبار'),
        content: TextField(
          controller: topicController,
          decoration: const InputDecoration(
            hintText: 'مثال: الرياضيات، العلوم، إلخ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateAndStartQuiz(context, topicController.text);
            },
            child: const Text('ابدأ'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAndStartQuiz(BuildContext context, String topic) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text('جارٍ تحميل الأسئلة...'),
        content: SizedBox(
          width: 100,
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    try {
      final questionGenerator = Get.find<EnhancedQuestionGenerator>();
      
      // Generate varied questions
      final variedQuestions = await questionGenerator.generateVariedQuestions(
        topic,
        'اختبار عام عن الموضوع',
        10,
      );

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Create a simple question list
      final allQuestions = <dynamic>[
        ...(variedQuestions['multipleChoice'] as List? ?? []),
        ...(variedQuestions['trueFalse'] as List? ?? []),
        ...(variedQuestions['fillInBlanks'] as List? ?? []),
        ...(variedQuestions['shortAnswer'] as List? ?? []),
      ];

      // Navigate to quiz results after validation
      if (context.mounted && allQuestions.isNotEmpty) {
        // Show results preview or create a custom quiz screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم توليد ${allQuestions.length} سؤال عن: $topic'),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.pop(context);
      
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
