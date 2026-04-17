import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/ai_services/ai_services.dart';

import '../../data/models/subject_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/practice_quiz_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

import 'package:quiz_master_app/ai_services/ai_services.dart';
 

// ✅ استيراد خدمات AI
import 'package:quiz_master_app/ai_services/curriculum_manager.dart';
import 'package:quiz_master_app/ai_services/question_generator_enhanced.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final SubjectRepository _subjectRepo = Get.find<SubjectRepository>();
  final PracticeQuizRepository _analyticsRepo =
      Get.find<PracticeQuizRepository>();

  final currentUser = Rxn<UserModel>();
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;

  final totalQuizzes = 0.obs;
  final averageScore = 0.0.obs;
  final streakDays = 0.obs;

  // ✅ حقول جديدة للـ streak
  final streakStatus = 'inactive'.obs; // active / warning / frozen / inactive
  final streakDaysLeft = Rxn<int>(); // كم يوم باقي من فترة السماح

  // ✅ حقول AI Tools
  final showAIMenu = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      currentUser.value = _storageService.user;

      final subjectsList = await _subjectRepo.getSubjectsWithStats();
      subjects.value = subjectsList;

      final analytics = await _analyticsRepo.getAnalytics();

      totalQuizzes.value = (analytics['totalQuizzes'] as num?)?.toInt() ?? 0;

      averageScore.value =
          (analytics['averageScore'] as num?)?.toDouble() ??
          (subjects.isNotEmpty && totalQuizzes.value > 0
              ? subjects.fold(
                      0.0,
                      (sum, s) => sum + s.averageScore * s.totalQuizzes,
                    ) /
                    totalQuizzes.value
              : 0.0);

      // ✅ streak الجديد
      streakDays.value = (analytics['streakDays'] as num?)?.toInt() ?? 0;
      streakStatus.value = (analytics['streakStatus'] as String?) ?? 'inactive';
      streakDaysLeft.value = (analytics['streakDaysLeft'] as num?)?.toInt();
    } catch (e) {
      subjects.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ هل يظهر بانر التحذير؟
  bool get showStreakWarning => streakStatus.value == 'warning';

  // ✅ هل انتهى الـ streak؟
  bool get isStreakFrozen => streakStatus.value == 'frozen';

  void goToSubjectDetails(SubjectModel subject) =>
      Get.toNamed(AppRoutes.SUBJECT_DETAILS, arguments: subject);

  void goToProfile() => Get.toNamed(AppRoutes.PROFILE);

  Future<void> refreshData() async => await _loadData();

  // ✅ ============ AI Tools Methods ============

  void toggleAIMenu() {
    showAIMenu.toggle();
  }

  // ✅ بدء اختبار المنهج
  Future<void> startCurriculumQuiz() async {
    try {
      showAIMenu.value = false;
      final curriculumManager = CurriculumManager();
      final jsonData = _getSampleCurriculumJson();
      await curriculumManager.loadCurriculumFromJson(jsonData);

      // الانتقال إلى شاشة اختيار المنهج
      Get.toNamed(
        AppRoutes.CURRICULUM_SELECTION,
        arguments: curriculumManager,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المنهج: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // ✅ حوار اختبار الموضوع
  void showTopicQuizDialog() {
    final topicController = TextEditingController();
    showAIMenu.value = false;

    Get.dialog(
      AlertDialog(
        title: const Text('اختبار مبني على موضوع'),
        content: TextField(
          controller: topicController,
          decoration: const InputDecoration(
            labelText: 'أدخل الموضوع',
            hintText: 'مثال: الرياضيات، الفيزياء',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (topicController.text.isNotEmpty) {
                generateTopicQuiz(topicController.text);
              }
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  // ✅ توليد اختبار الموضوع
  Future<void> generateTopicQuiz(String topic) async {
    Get.dialog(
      const AlertDialog(
        title: Text('جارٍ توليد الأسئلة...'),
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final questionGenerator = EnhancedQuestionGenerator();
      final variedQuestions =
          await questionGenerator.generateVariedQuestions(topic, 'اختبار عام', 10);

      Get.back();
      Get.snackbar(
        'نجح',
        'تم توليد ${variedQuestions.length} سؤال عن: $topic',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        'فشل التوليد: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('حطاءاااابيبيييبي: $e');
    }
  }

  // ✅ حوار الاختبار المخصص
  void showCustomQuizDialog() {
    final topicController = TextEditingController();
    final countController = TextEditingController(text: '10');
    final typeValue = 'varied'.obs;
    showAIMenu.value = false;

    Get.dialog(
      AlertDialog(
        title: const Text('إنشاء اختبار مخصص'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: topicController,
                decoration: const InputDecoration(
                  labelText: 'الموضوع',
                  hintText: 'مثال: الرياضيات',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: countController,
                decoration: const InputDecoration(
                  labelText: 'عدد الأسئلة',
                  hintText: '10',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: typeValue.value,
                  decoration: const InputDecoration(
                    labelText: 'نوع الأسئلة',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'varied', child: Text('متنوعة')),
                    DropdownMenuItem(value: 'mc', child: Text('اختيار من متعدد')),
                    DropdownMenuItem(value: 'tf', child: Text('صحيح/خطأ')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      typeValue.value = value;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              generateCustomQuiz(
                topicController.text,
                int.tryParse(countController.text) ?? 10,
                typeValue.value,
              );
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  // ✅ توليد اختبار مخصص
  Future<void> generateCustomQuiz(String topic, int count, String type) async {
    if (topic.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال الموضوع',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.dialog(
      const AlertDialog(
        title: Text('جارٍ التوليد...'),
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final questionGenerator = EnhancedQuestionGenerator();

      if (type == 'mc') {
        await questionGenerator.generateMultipleChoice(topic, count);
      } else if (type == 'tf') {
        await questionGenerator.generateTrueFalse(topic, count);
      } else {
        await questionGenerator.generateVariedQuestions(topic, '', count);
      }

      Get.back();
      Get.snackbar('نجح', 'تم توليد الأسئلة بنجاح!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } catch (e) {
      Get.back();
      Get.snackbar('خطأ', 'فشل التوليد: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
          print('حطاءاااابيبيييبي: $e');
    }
  }

  // ✅ عرض معلومات المنهج
  void showCurriculumInfo() {
    showAIMenu.value = false;
    Get.dialog(
      AlertDialog(
        title: const Text('معلومات المنهج'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المنهج الدراسي جاهز للاستخدام'),
            SizedBox(height: 12),
            Text('الميزات:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('• توليد أسئلة متنوعة'),
            Text('• أنواع مختلفة من الأسئلة'),
            Text('• تحليل الأداء'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // ✅ الحصول على بيانات المنهج التجريبية
  String _getSampleCurriculumJson() {
    return '''{
  "stages": [
    {
      "id": "stage_1",
      "name": "المرحلة الابتدائية",
      "subjects": [
        {
          "id": "subject_1_1",
          "name": "الرياضيات",
          "icon": "🔢",
          "description": "الأعداد والعمليات",
          "semesters": [
            {
              "id": "semester_1",
              "name": "الفصل الأول",
              "units": [
                {
                  "id": "unit_1",
                  "name": "الأعداد من 1 إلى 100",
                  "description": "تعليم الأعداد",
                  "lessons": [
                    {"id": "l1", "name": "الأعداد الأساسية"}
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}''';
  }
}
