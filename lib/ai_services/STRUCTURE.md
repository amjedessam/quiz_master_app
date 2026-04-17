# AI Services Module - Quick Reference

## 📑 فهرس سريع للملفات

### 🔧 الملفات الأساسية
- **ai_services.dart** - نقطة الدخول الرئيسية (exports)
- **config.dart** - إعدادات API والثوابت
- **models.dart** - 10+ نماذج بيانات مشروعة

### 🤖 خدمات الذكاء الاصطناعي
- **ai_service.dart** - خدمة AI الأساسية (generic)
- **question_generator_enhanced.dart** - توليد أسئلة متنوعة
- **curriculum_manager.dart** - إدارة المنهج الدراسي

### 🎨 الواجهات (Flutter Screens)
- **screens/curriculum_selection_screen.dart** - اختيار المنهج
- **screens/quiz_screen.dart** - الاختبار التفاعلي الرئيسي
- **screens/quiz_result_screen.dart** - عرض النتائج والإحصائيات
- **screens/question_widget.dart** - widget عرض الأسئلة المختلفة

### 📚 البيانات والتوثيق
- **sample_curriculum.json** - بيانات منهج تجريبية
- **README.md** - الدليل الشامل للاستخدام
- **GUIDE.md** - دليل متقدم مفصل
- **PROJECT_SUMMARY.md** - ملخص المشروع
- **STRUCTURE.md** - هذا الملف

### 💡 الأمثلة
- **example.dart** - أمثلة الاستخدام الأساسية
- **integration_example.dart** - مثال على الدمج الكامل

---

## 🚀 البدء السريع

### 1. الاستيراد
```dart
import 'package:ai_services/ai_services.dart';
```

### 2. الإعداد
```dart
final curriculumManager = CurriculumManager();
final questionGenerator = EnhancedQuestionGenerator();
await curriculumManager.loadCurriculumFromJson(jsonData);
```

### 3. الاستخدام
```dart
// الطريقة الأولى: المنهج
Navigator.push(context, MaterialPageRoute(
  builder: (ctx) => CurriculumSelectionScreen(
    curriculumManager: curriculumManager,
    onUnitSelected: (stage, subject, semester, unit) {
      Navigator.push(ctx, MaterialPageRoute(
        builder: (ctx) => QuizScreen(
          stageId: stage,
          subjectId: subject,
          semesterId: semester,
          unitId: unit,
          curriculumManager: curriculumManager,
          questionGenerator: questionGenerator,
        ),
      ));
    },
  ),
));
```

---

## 📊 نموذج البيانات

### الهيكل التعليمي:
```
Stage
├── id: String
├── name: String
└── subjects: List<Subject>
    ├── id: String
    ├── name: String
    ├── icon: String
    ├── description: String
    └── semesters: List<Semester>
        ├── id: String
        ├── name: String
        └── units: List<Unit>
            ├── id: String
            ├── name: String
            ├── description: String
            └── lessons: List<Lesson>
                ├── id: String
                ├── name: String
                ├── content: String
                └── keyPoints: List<String>
```

### أنواع الأسئلة:
- **Question** - اختيار من متعدد
- **TrueFalseQuestion** - صحيح/خطأ
- **FillInTheBlanksQuestion** - ملء الفراغات
- **MultiSelectQuestion** - متعددة التحديد
- **ShortAnswerQuestion** - إجابة قصيرة

### النتائج:
- **QuizResult** - نتيجة الاختبار الكاملة
- **QuestionResult** - نتيجة كل سؤال

---

## ⚙️ الخيارات المتاحة

### توليد الأسئلة:
```dart
// أسئلة متنوعة
final varied = await gen.generateVariedQuestions(topic, context, 10);

// نوع محدد
final mc = await gen.generateMultipleChoice(topic, 5);
final tf = await gen.generateTrueFalse(topic, 5);
final fill = await gen.generateFillInBlanks(topic, 5);
final multi = await gen.generateMultiSelect(topic, 5);
final short = await gen.generateShortAnswer(topic, 5);
```

### الوصول للمنهج:
```dart
final stages = manager.getAllStages();
final subjects = manager.getSubjectsForStage(stageId);
final semesters = manager.getSemestersForSubject(stageId, subjectId);
final units = manager.getUnitsForSemester(stageId, subjectId, semesterId);
final lessons = manager.getLessonsForUnit(stageId, subjectId, semesterId, unitId);
```

### الإحصائيات:
```dart
final stats = manager.getCurriculumStats();
final context = manager.generateQuizContext(stage, subject, semester, unit);
```

---

## 🔐 الأمان والخصوصية

- 🔒 فصل كامل عن الكود الرئيسي
- 🔑 مفاتيح API آمنة في config
- 📝 معالجة أخطاء قوية
- 🛡️ تحقق من صيغة البيانات

---

## 🎯 حالات الاستخدام

| الحالة | الملف | الطريقة |
|--------|------|--------|
| اختبار منهج | QuizScreen | حدد المرحلة/المادة/... |
| اختبار موضوع | EnhancedQuestionGenerator | أدخل الموضوع |
| تحليل الأداء | QuizResultScreen/DataAnalysis | عرض النتائج |
| إدارة بيانات | CurriculumManager | حمل من JSON |

---

## 📦 التبعيات الإضافية
```yaml
dio: ^5.9.1          # HTTP requests
get: ^4.6.6          # State management
```

---

## 🔗 الروابط السريعة

- **README.md** - دليل شامل
- **GUIDE.md** - أمثلة متقدمة
- **PROJECT_SUMMARY.md** - ملخص الميزات
- **integration_example.dart** - مثال تطبيق كامل
- **sample_curriculum.json** - بيانات تجريبية

---

**آخر تحديث:** أبريل 2026  
**الإصدار:** 1.0.0
