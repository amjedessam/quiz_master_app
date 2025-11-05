import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class AnalyticsController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;

  final isLoading = false.obs;

  final totalQuizzes = 69.obs;
  final averageScore = 78.5.obs;
  final streakDays = 12.obs;
  final totalTimeSpent = 2340.obs;

  final subjectPerformance = [
    {'name': 'الرياضيات', 'score': 85.0, 'quizzes': 24, 'color': '0xFF6C63FF'},
    {'name': 'الفيزياء', 'score': 78.0, 'quizzes': 18, 'color': '0xFF00D9FF'},
    {'name': 'الكيمياء', 'score': 72.5, 'quizzes': 15, 'color': '0xFF4CAF50'},
    {'name': 'الأحياء', 'score': 68.0, 'quizzes': 12, 'color': '0xFFFF9800'},
  ].obs;

  final masteryLevels = [
    {'skill': 'التذكر', 'percentage': 85.0},
    {'skill': 'الفهم', 'percentage': 78.0},
    {'skill': 'التطبيق', 'percentage': 72.0},
    {'skill': 'التحليل', 'percentage': 65.0},
  ].obs;

  final weakTopics = [
    {
      'name': 'المتجهات في الفضاء',
      'rate': 45.0,
      'subject': 'الرياضيات',
      'wrongQuestions': [
        {
          'content': 'ما هو حاصل الضرب الاتجاهي للمتجهين A و B؟',
          'userAnswer': 'A',
          'correctAnswer': 'C',
          'explanation': 'حاصل الضرب الاتجاهي يُحسب باستخدام...',
          'skill': 'apply',
          'difficulty': 'hard',
          'referencePage': 'ص 125',
        },
        {
          'content': 'إذا كان المتجه A = (2,3,4) فما طوله؟',
          'userAnswer': null,
          'correctAnswer': 'B',
          'explanation': 'طول المتجه = الجذر التربيعي لمجموع مربعات المركبات',
          'skill': 'apply',
          'difficulty': 'medium',
          'referencePage': 'ص 120',
        },
      ],
    },
    {
      'name': 'الحركة الدائرية',
      'rate': 52.0,
      'subject': 'الفيزياء',
      'wrongQuestions': [
        {
          'content': 'ما هي العلاقة بين السرعة الزاوية والخطية؟',
          'userAnswer': 'B',
          'correctAnswer': 'A',
          'explanation': 'السرعة الخطية = السرعة الزاوية × نصف القطر',
          'skill': 'understand',
          'difficulty': 'medium',
          'referencePage': 'ص 85',
        },
      ],
    },
    {
      'name': 'التفاعلات الكيميائية',
      'rate': 48.0,
      'subject': 'الكيمياء',
      'wrongQuestions': [
        {
          'content': 'ما نوع التفاعل: 2H₂ + O₂ → 2H₂O؟',
          'userAnswer': 'C',
          'correctAnswer': 'A',
          'explanation': 'هذا تفاعل تكوين (Synthesis)',
          'skill': 'remember',
          'difficulty': 'easy',
          'referencePage': 'ص 45',
        },
      ],
    },
  ].obs;

  final performanceHistory = [
    {'day': 'السبت', 'score': 75.0},
    {'day': 'الأحد', 'score': 82.0},
    {'day': 'الاثنين', 'score': 78.0},
    {'day': 'الثلاثاء', 'score': 85.0},
    {'day': 'الأربعاء', 'score': 80.0},
    {'day': 'الخميس', 'score': 88.0},
    {'day': 'الجمعة', 'score': 90.0},
  ].obs;

  final recommendations = [
    'ركز على مراجعة موضوع "المتجهات في الفضاء" في الرياضيات',
    'قم بحل المزيد من التمارين في "الحركة الدائرية" بالفيزياء',
    'راجع الأمثلة العملية في "التفاعلات الكيميائية"',
    'واصل التقدم الممتاز في مهارة "التذكر"',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchAnalytics();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchAnalytics() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }

  void explainWeakTopic(Map<String, dynamic> topic) {
    final wrongQuestions =
        topic['wrongQuestions'] as List<Map<String, dynamic>>;
    final topicName = topic['name'] as String;

    Get.toNamed(
      AppRoutes.EXPLANATION,
      arguments: {
        'mode': 'auto',
        'weakTopics': [topicName],
        'wrongQuestions': wrongQuestions,
      },
    );
  }

  void goToHistory() {
    Get.toNamed(AppRoutes.HISTORY);
  }
}
