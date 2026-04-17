# AI Services - خدمة الذكاء الاصطناعي التعليمية

خدمة ذكاء اصطناعي منفصلة لتوليد الاختبارات والأسئلة وتحليل البيانات. مصممة لتكون مستقلة عن الكود الرئيسي ويمكن نسخها بسهولة إلى مشاريع أخرى.

## الميزات الرئيسية

### 1. تنظيم المنهج الدراسي
- هيكل متسلسل: المرحلة → المادة → الفصل الدراسي → الوحدات → الدروس
- إدارة كاملة للمنهج الدراسي
- تحميل المنهج من ملفات JSON

### 2. توليد أسئلة متنوعة
- **أسئلة اختيار من متعدد** (Multiple Choice)
- **أسئلة صحيح/خطأ** (True/False)
- **أسئلة ملء الفراغات** (Fill in the Blanks)
- **أسئلة متعددة التحديد** (Multi-Select)
- **أسئلة الإجابة القصيرة** (Short Answer)
- **تنوع الأسئلة** يعطي تجربة ممتازة للمستخدم

### 3. واجهات تفاعلية
- شاشة اختيار المنهج الدراسي
- شاشة الاختبار التفاعلية
- شاشة النتائج والإحصائيات
- تتبع الوقت والأداء

### 4. تحليل البيانات
- حساب النسب المئوية
- تتبع الأداء
- إحصائيات مفصلة للإجابات

## التبعيات المطلوبة

- `dio`: للطلبات HTTP
- `get`: لإدارة الحالة والملاحة
- مفتاح API لـ OpenAI

## كيفية الاستخدام

### 1. الإعداد الأساسي

```dart
import 'package:ai_services/ai_services.dart';

// إنشاء مدير المنهج
final curriculumManager = CurriculumManager();

// تحميل المنهج من JSON
const curriculumJson = '...'; // محتوى الملف JSON
await curriculumManager.loadCurriculumFromJson(curriculumJson);

// إنشاء مولد الأسئلة
final questionGenerator = EnhancedQuestionGenerator();
```

### 2. الوصول إلى المنهج

```dart
// الحصول على جميع المراحل
final stages = curriculumManager.getAllStages();

// الحصول على المواد لمرحلة معينة
final subjects = curriculumManager.getSubjectsForStage(stageId);

// الحصول على الفصول الدراسية
final semesters = curriculumManager.getSemestersForSubject(stageId, subjectId);

// الحصول على الوحدات
final units = curriculumManager.getUnitsForSemester(stageId, subjectId, semesterId);

// الحصول على الدروس
final lessons = curriculumManager.getLessonsForUnit(stageId, subjectId, semesterId, unitId);
```

### 3. توليد أسئلة متنوعة

```dart
// توليد أسئلة متنوعة
final variedQuestions = await questionGenerator.generateVariedQuestions(
  'الموضوع',
  'السياق التعليمي',
  10 // عدد الأسئلة الكلي
);

// النتيجة تحتوي على:
// - multipleChoice: أسئلة اختيار من متعدد
// - trueFalse: أسئلة صحيح/خطأ
// - fillInBlanks: أسئلة ملء الفراغات
// - shortAnswer: أسئلة الإجابة القصيرة
```

### 4. توليد نوع محدد من الأسئلة

```dart
// أسئلة اختيار من متعدد فقط
final multipleChoice = await questionGenerator.generateMultipleChoice('الموضوع', 5);

// أسئلة صحيح/خطأ فقط
final trueFalse = await questionGenerator.generateTrueFalse('الموضوع', 5);

// أسئلة ملء الفراغات
final fillBlanks = await questionGenerator.generateFillInBlanks('الموضوع', 5);

// أسئلة متعددة التحديد
final multiSelect = await questionGenerator.generateMultiSelect('الموضوع', 5);

// أسئلة الإجابة القصيرة
final shortAnswer = await questionGenerator.generateShortAnswer('الموضوع', 5);
```

### 5. استخدام الواجهات التفاعلية

```dart
// شاشة اختيار المنهج
Navigator.push(context, MaterialPageRoute(
  builder: (context) => CurriculumSelectionScreen(
    curriculumManager: curriculumManager,
    onUnitSelected: (stageId, subjectId, semesterId, unitId) {
      // بدء الاختبار
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuizScreen(
          stageId: stageId,
          subjectId: subjectId,
          semesterId: semesterId,
          unitId: unitId,
          curriculumManager: curriculumManager,
          questionGenerator: questionGenerator,
        ),
      ));
    },
  ),
));
```

## بيانات المنهج (JSON)

المنهج يجب أن يكون بالتنسيق التالي:

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
          "description": "وصف المادة",
          "semesters": [
            {
              "id": "semester_1_1_1",
              "name": "الفصل الدراسي الأول",
              "units": [
                {
                  "id": "unit_1",
                  "name": "الوحدة الأولى",
                  "description": "وصف الوحدة",
                  "lessons": [
                    {
                      "id": "lesson_1",
                      "name": "الدرس الأول",
                      "content": "محتوى الدرس",
                      "keyPoints": ["نقطة رئيسية 1", "نقطة رئيسية 2"]
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

## نسخ إلى مشروع آخر

1. انسخ مجلد `ai_services` بالكامل إلى `lib/` في المشروع الجديد
2. أضف `dio` و `get` إلى `pubspec.yaml`:
   ```yaml
   dependencies:
     dio: ^5.9.1
     get: ^4.6.6
   ```
3. أضف مفتاح OpenAI API في `config.dart`
4. قم بتحميل بيانات المنهج (JSON) عند بدء التطبيق

## الملفات الرئيسية

- `ai_services.dart`: ملف التصدير الرئيسي
- `models.dart`: نماذج البيانات المختلفة
- `ai_service.dart`: خدمة AI الأساسية
- `curriculum_manager.dart`: إدارة المنهج الدراسي
- `question_generator_enhanced.dart`: توليد الأسئلة المتنوعة
- `screens/`: واجهات Flutter التفاعلية
- `sample_curriculum.json`: مثال على بيانات المنهج
- `config.dart`: الإعدادات والمفاتيح

## الإحصائيات المدعومة

- معدل النجاح
- عدد الأسئلة الصحيحة والخاطئة
- الوقت المستغرق في الاختبار
- الوقت المستغرق لكل سؤال
- أداء الطالب عبر الاختبارات المختلفة
