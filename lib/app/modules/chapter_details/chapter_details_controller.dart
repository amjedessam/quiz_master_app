import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/subject_model.dart';
import '../../data/models/chapter_model.dart';
import '../../routes/app_routes.dart';

class ChapterDetailsController extends GetxController {
  final subject = Rxn<SubjectModel>();
  final chapter = Rxn<ChapterModel>();
  final isLoading = false.obs;

  final topics = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    subject.value = args['subject'];
    chapter.value = args['chapter'];
    _loadChapterContent();
  }

  Future<void> _loadChapterContent() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    topics.value = [
      {
        'id': '1',
        'title': 'المقدمة والتعاريف الأساسية',
        'description': 'نظرة عامة على الموضوع والمفاهيم الأساسية',
        'duration': '15 دقيقة',
        'questionsCount': 8,
        'isCompleted': true,
      },
      {
        'id': '2',
        'title': 'الشرح التفصيلي',
        'description': 'شرح مفصل للمفاهيم والقوانين',
        'duration': '25 دقيقة',
        'questionsCount': 12,
        'isCompleted': true,
      },
      {
        'id': '3',
        'title': 'الأمثلة المحلولة',
        'description': 'أمثلة عملية مع الحلول الكاملة',
        'duration': '20 دقيقة',
        'questionsCount': 10,
        'isCompleted': false,
      },
      {
        'id': '4',
        'title': 'التطبيقات والتمارين',
        'description': 'تمارين متنوعة على الموضوع',
        'duration': '30 دقيقة',
        'questionsCount': 15,
        'isCompleted': false,
      },
      {
        'id': '5',
        'title': 'المراجعة النهائية',
        'description': 'مراجعة شاملة لجميع نقاط الفصل',
        'duration': '20 دقيقة',
        'questionsCount': 20,
        'isCompleted': false,
      },
    ];

    isLoading.value = false;
  }

  void startQuiz() {
    Get.toNamed(
      AppRoutes.MainTabView,
      arguments: {
        'subject': subject.value,
        'chapter': chapter.value,
        'autoSelect': true,
      },
    );
  }

  void viewSummary() {
    _generateSummaryDirectly();
  }

  void requestExplanation() {
    _generateExplanationDirectly();
  }

  void viewTopic(Map<String, dynamic> topic) {
    Get.snackbar(
      'الموضوع: ${topic['title']}',
      topic['description'],
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> refreshData() async {
    await _loadChapterContent();
  }

  Future<void> _generateSummaryDirectly() async {
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري إنشاء الملخص...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 3));

    Get.back();

    final summaryData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'summary',
      'title': 'ملخص: ${chapter.value!.name}',
      'subject': subject.value!.name,
      'chapter': chapter.value!.name,
      'date': DateTime.now(),
      'content':
          '''
# ${chapter.value!.name}

## نظرة عامة:
${subject.value!.name} - ${chapter.value!.name}

## النقاط الرئيسية:

### 1. المقدمة والتعاريف
• التعريف الأساسي للموضوع
• المفاهيم المرتبطة
• الأهمية في المنهج

### 2. المفاهيم الأساسية
• المفهوم الأول: شرح مفصل...
• المفهوم الثاني: شرح مفصل...
• المفهوم الثالث: شرح مفصل...

### 3. القوانين والقواعد
📌 القانون الأول: ...
📌 القانون الثاني: ...
📌 القانون الثالث: ...

### 4. أمثلة محلولة

مثال 1:
المعطيات: ...
المطلوب: ...
الحل: ...

مثال 2:
المعطيات: ...
المطلوب: ...
الحل: ...

### 5. نقاط مهمة للحفظ
⭐ تذكر أن...
⭐ انتبه إلى...
⭐ لا تنسى...

### 6. تمارين مقترحة
1. تمرين 1: ...
2. تمرين 2: ...
3. تمرين 3: ...

## ملاحظات إضافية:
💡 نصيحة: راجع الأمثلة جيداً
💡 ركز على فهم المفاهيم وليس الحفظ فقط

---
تم إنشاء هذا الملخص تلقائياً بناءً على ${chapter.value!.name}
المرجع: ${chapter.value!.name}، عدد الأسئلة: ${chapter.value!.questionsCount}
    ''',
    };

    Get.toNamed(AppRoutes.SUMMARY_DETAIL, arguments: summaryData);
  }

  Future<void> _generateExplanationDirectly() async {
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('جاري إعداد الشرح...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 3));

    Get.back();

    Get.toNamed(
      AppRoutes.EXPLANATION,
      arguments: {
        'mode': 'direct',
        'subject': subject.value!.name,
        'chapter': chapter.value!.name,
        'content':
            '''
# شرح شامل: ${chapter.value!.name}

## 📚 ${subject.value!.name} - ${chapter.value!.name}

---

## 🎯 الأهداف التعليمية:
بنهاية دراسة هذا الفصل، ستتمكن من:
• فهم المفاهيم الأساسية
• تطبيق القوانين والقواعد
• حل المسائل المتنوعة
• ربط المفاهيم ببعضها

---

## 📖 الشرح التفصيلي:

### الجزء الأول: المقدمة

يعتبر هذا الموضوع من المواضيع الأساسية في ${subject.value!.name}. 
يتناول هذا الفصل مجموعة من المفاهيم المترابطة التي تشكل أساساً لفهم المواضيع المتقدمة.

لماذا هذا الموضوع مهم؟
• يبني أساساً قوياً للمواضيع القادمة
• يطور مهارات التفكير والتحليل
• له تطبيقات عملية في الحياة اليومية

---

### الجزء الثاني: المفاهيم الأساسية

#### المفهوم الأول: التعريف
التعريف: شرح مفصل للمفهوم الأول...

الخصائص:
• الخاصية الأولى: ...
• الخاصية الثانية: ...
• الخاصية الثالثة: ...

مثال توضيحي:
لنفترض أن لدينا...
الحل: ...

---

#### المفهوم الثاني: التطبيق
كيف نطبق هذا المفهوم؟
1. الخطوة الأولى: ...
2. الخطوة الثانية: ...
3. الخطوة الثالثة: ...

مثال عملي:
إذا كان لدينا...
الحل خطوة بخطوة:
• أولاً: ...
• ثانياً: ...
• ثالثاً: ...

---

### الجزء الثالث: القوانين والصيغ

#### القانون الأول
📐 الصيغة: ...
📝 متى نستخدمه: ...
⚠️ ملاحظات مهمة: ...

#### القانون الثاني
📐 الصيغة: ...
📝 متى نستخدمه: ...
⚠️ ملاحظات مهمة: ...

---

### الجزء الرابع: أمثلة محلولة

#### مثال (1): مسألة بسيطة
المعطيات:
• المعطى الأول: ...
• المعطى الثاني: ...المطلوب: ...

الحل:
نستخدم القانون...
الخطوات:
1. ...
2. ...
3. ...

الإجابة النهائية: ...

---

#### مثال (2): مسألة متوسطة
المعطيات:
• ...

المطلوب: ...

الحل: ...

---

#### مثال (3): مسألة متقدمة
المعطيات:
• ...

المطلوب: ...

الحل: ...

---

## 💡 نصائح وإرشادات:

### نصائح للحفظ:
• استخدم الرسوم التوضيحية
• اربط المفاهيم الجديدة بما تعرفه
• راجع بانتظام

### نصائح للفهم:
• لا تعتمد على الحفظ فقط
• حل تمارين متنوعة
• اطرح أسئلة على نفسك

### أخطاء شائعة يجب تجنبها:
❌ الخطأ الأول: ...
✅ الصحيح: ...

❌ الخطأ الثاني: ...
✅ الصحيح: ...

---

## 📝 تمارين إضافية:

### تمارين سهلة:
1. ...
2. ...
3. ...

### تمارين متوسطة:
1. ...
2. ...
3. ...

### تمارين صعبة:
1. ...
2. ...
3. ...

---

## 🔗 ربط مع مواضيع أخرى:

هذا الموضوع يرتبط بـ:
• الموضوع السابق: ...
• الموضوع اللاحق: ...
• تطبيقات في مواد أخرى: ...

---

## ✅ خلاصة الفصل:

النقاط الرئيسية:
1. المفهوم الأول: ...
2. المفهوم الثاني: ...
3. المفهوم الثالث: ...

القوانين المهمة:
• القانون الأول: ...
• القانون الثاني: ...

ما يجب أن تتذكره:
💫 النقطة الأولى
💫 النقطة الثانية
💫 النقطة الثالثة

---

## 📚 للمراجعة:
• عد إلى الكتاب: صفحة ...
• حل تمارين الكتاب: من ... إلى ...
• راجع الأمثلة المحلولة

---

تم إنشاء هذا الشرح تلقائياً لـ ${chapter.value!.name}
عدد الأسئلة في البنك: ${chapter.value!.questionsCount}
''',
      },
    );
  }
}
