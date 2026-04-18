## خدمة الذكاء الاصطناعي التعليمية - دليل شامل

---

### 📋 هيكل المشروع

```
lib/ai_services/
├── 📄 ai_services.dart              - الملف الرئيسي للتصدير
├── 📄 config.dart                   - إعدادات API
├── 📄 models.dart                   - نماذج البيانات (الهيكل التعليمي + أنواع الأسئلة)
├── 📄 ai_service.dart               - الخدمة الأساسية
├── 📄 curriculum_manager.dart       - إدارة المنهج الدراسي
├── 📄 question_generator_enhanced.dart - توليد الأسئلة المتنوعة
├── 📄 integration_example.dart      - مثال على الدمج
├── 📄 example.dart                  - أمثلة استخدام
├── 📄 sample_curriculum.json        - بيانات المنهج التجريبية
├── 📄 README.md                     - الدليل الكامل
└── 📁 screens/
    ├── curriculum_selection_screen.dart  - اختيار المنهج
    ├── quiz_screen.dart                  - الاختبار التفاعلي
    ├── quiz_result_screen.dart           - النتائج والإحصائيات
    └── question_widget.dart              - عرض أنواع الأسئلة
```

---

### 🔑 المميزات الرئيسية

#### 1️⃣ هيكل المنهج الدراسي
**النموذج الهرمي:**
```
المرحلة (Stage)
    └─ المادة (Subject)
        └─ الفصل الدراسي (Semester)
            └─ الوحدة (Unit)
                └─ الدرس (Lesson)
```

#### 2️⃣ أنواع الأسئلة المدعومة
- ✅ **Multiple Choice** - اختيار من متعدد
- ✅ **True/False** - صحيح/خطأ
- ✅ **Fill in the Blanks** - ملء الفراغات
- ✅ **Multi-Select** - متعددة التحديد
- ✅ **Short Answer** - الإجابة القصيرة

#### 3️⃣ إحصائيات وتقارير
- 📊 معدل النجاح (%)
- 📈 تتبع الأداء
- ⏱️ الوقت المستغرق
- 📝 تحليل الإجابات

---

### 🚀 دليل الاستخدام السريع

#### الخطوة 1: الإعداد
```dart
// استيراد الخدمة
import 'package:ai_services/ai_services.dart';

// إنشاء مدير المنهج
final curriculumManager = CurriculumManager();

// تحميل المنهج من JSON
await curriculumManager.loadCurriculumFromJson(jsonData);

// إنشاء مولد الأسئلة
final questionGenerator = EnhancedQuestionGenerator();
```

#### الخطوة 2: الوصول إلى المنهج
```dart
// الحصول على المراحل
final stages = curriculumManager.getAllStages();

// الحصول على المواد
final subjects = curriculumManager.getSubjectsForStage('stage_1');

// الحصول على الوحدات
final units = curriculumManager.getUnitsForSemester(
  'stage_1',
  'subject_1',
  'semester_1'
);
```

#### الخطوة 3: توليد الأسئلة
```dart
// أسئلة متنوعة
final variedQuestions = await questionGenerator.generateVariedQuestions(
  'الرياضيات',
  'context_info',
  10
);

// أسئلة محددة
final mcQuestions = await questionGenerator.generateMultipleChoice('الموضوع', 5);
final tfQuestions = await questionGenerator.generateTrueFalse('الموضوع', 5);
```

#### الخطوة 4: عرض الاختبار
```dart
Navigator.push(context, MaterialPageRoute(
  builder: (context) => QuizScreen(
    stageId: 'stage_1',
    subjectId: 'subject_1',
    semesterId: 'semester_1',
    unitId: 'unit_1',
    curriculumManager: curriculumManager,
    questionGenerator: questionGenerator,
  ),
));
```

---

### 📐 نموذج بيانات المنهج (JSON)

```json
{
  "stages": [
    {
      "id": "stage_1",
      "name": "المرحلة الابتدائية",
      "subjects": [
        {
          "id": "subject_1_1",
          "name": "الرياضيات",
          "icon": "🔢",
          "description": "دراسة الأعداد والعمليات",
          "semesters": [
            {
              "id": "semester_1_1_1",
              "name": "الفصل الأول",
              "units": [
                {
                  "id": "unit_1",
                  "name": "الأعداد والعد",
                  "description": "تعلم الأعداد من 1 إلى 100",
                  "lessons": [
                    {
                      "id": "lesson_1",
                      "name": "الأعداد من 1 إلى 10",
                      "content": "محتوى الدرس",
                      "keyPoints": ["النقطة 1", "النقطة 2"]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

---

### 🎯 حالات الاستخدام

#### 1. اختبار مبني على المنهج
```dart
// المستخدم يختار: المرحلة → المادة → الفصل → الوحدة
// ثم يبدأ الاختبار التفاعلي
// النظام يقدم تقارير مفصلة
```

#### 2. اختبار مبني على موضوع
```dart
// المستخدم يدخل موضوع
// النظام يولد أسئلة متنوعة تلقائياً
// يقدم نتائج فورية
```

#### 3. تحليل الأداء
```dart
final analysis = await aiService.analyzeData(quizResults);
// النتيجة تتضمن ملخص الأداء والنقاط الضعيفة
```

---

### 📦 البيانات المرجعة

#### نموذج الاختبار
```dart
QuizResult {
  quizId: String,
  studentId: String,
  completedAt: DateTime,
  totalQuestions: int,
  correctAnswers: int,
  timeTaken: Duration,
  results: List<QuestionResult>
}
```

#### نموذج الإجابة
```dart
QuestionResult {
  questionId: String,
  userAnswer: String,
  isCorrect: bool,
  timeSpent: Duration
}
```

---

### 🔧 الخيارات المتقدمة

#### توليد أسئلة موزونة
```dart
// الحصول على السياق التعليمي
final context = curriculumManager.generateQuizContext(
  'stage_1',
  'subject_1',
  'semester_1',
  'unit_1'
);

// توليد أسئلة مبنية على السياق
final questions = await questionGenerator.generateVariedQuestions(
  'الموضوع',
  context,
  15
);
```

#### التحقق من صحة الإجابات
```dart
final isCorrect = _isAnswerCorrect(question, userAnswer);
// يدعم التحقق الذكي للإجابات المختلفة
```

#### الإحصائيات المتقدمة
```dart
final stats = curriculumManager.getCurriculumStats();
// يتضمن:
// - إجمالي المراحل
// - إجمالي المواد
// - إجمالي الدروس
// وغيرها...
```

---

### 💾 التخزين والمثابرة

#### حفظ نتائج الاختبار
```dart
// يمكنك تخزين QuizResult في قاعدة البيانات المحلية
final json = quizResult.toJson();
await database.insert('quiz_results', json);
```

#### قراءة النتائج المحفوظة
```dart
final json = await database.query('quiz_results');
final results = json.map((j) => QuizResult.fromJson(j)).toList();
```

---

### 🎨 تخصيص الواجهات

#### تخصيص أسلوب الأسئلة
```dart
// يمكنك تخصيص QuestionDisplay widget
// تحديث الألوان والخطوط والرسوم التوضيحية
```

#### تخصيص نتائج الاختبار
```dart
// يمكنك تخصيص QuizResultScreen
// إضافة رسوم بيانية ومزيد من التفاصيل
```

---

### 🚨 معالجة الأخطاء

```dart
try {
  final questions = await questionGenerator.generateVariedQuestions(
    'الموضوع',
    'السياق',
    10,
  );
} catch (e) {
  // تعامل مع الخطأ
  print('خطأ: $e');
  // إعادة محاولة أو عرض رسالة خطأ للمستخدم
}
```

---

### 📞 الدعم والمساعدة

**المشاكل الشائعة:**

1. **خطأ في تحميل API**
   - تحقق من مفتاح OpenAI في `config.dart`
   - تأكد من اتصالك بالإنترنت

2. **أسئلة فارغة**
   - تأكد من صيغة JSON الصحيحة
   - تحقق من السياق المرسوما

3. **بطء في التحميل**
   - قلل عدد الأسئلة المطلوبة
   - استخدم caching لتسريع التحميل

---

### ✅ قائمة التحقق

- [ ] تحديث مفتاح OpenAI
- [ ] تحميل بيانات المنهج الصحيحة
- [ ] اختبار الواجهات على أجهزة مختلفة
- [ ] التحقق من الأداء والسرعة
- [ ] تثبيت نظام التتبع للنتائج
- [ ] كتابة tests للخدمات

---

**النسخة**: 1.0.0  
**آخر تحديث**: أبريل 2026
