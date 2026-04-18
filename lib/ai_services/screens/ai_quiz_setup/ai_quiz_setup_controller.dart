// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../curriculum_manager.dart';
// import '../../question_generator_enhanced.dart';
// import '../../models.dart';
// import '../ai_quiz/ai_quiz_screen.dart';

// class AiQuizSetupController extends GetxController {
//   final CurriculumManager curriculumManager;
//   final EnhancedQuestionGenerator questionGenerator;

//   final selectedStageId = RxnString();
//   final selectedSemesterId = RxnString();
//   final selectedSubjectId = RxnString();
//   final selectedUnitId = RxnString();
//   final questionCount = 10.obs;
//   final selectedDifficulty = 'easy'.obs;

//   AiQuizSetupController({
//     CurriculumManager? curriculumManager,
//     EnhancedQuestionGenerator? questionGenerator,
//   })  : curriculumManager = curriculumManager ?? CurriculumManager(),
//         questionGenerator = questionGenerator ?? EnhancedQuestionGenerator();

//   @override
//   void onInit() {
//     super.onInit();
//     _loadCurriculumData();
//   }

//   Future<void> _loadCurriculumData() async {
//     try {
//       // Load curriculum data from JSON file
//       final jsonString = await rootBundle.loadString('lib/ai_services/sample_curriculum.json');
//       await curriculumManager.loadCurriculumFromJson(jsonString);
//       _initializeSelection();
//     } catch (e) {
//       print('Error loading curriculum data: $e');
//       // Fallback to empty selection
//     }
//   }

//   void _initializeSelection() {
//     final stageList = curriculumManager.getAllStages();
//     if (stageList.isNotEmpty) {
//       selectedStageId.value = stageList.first.id;
//       final availableParts = parts;
//       if (availableParts.isNotEmpty) {
//         selectedSemesterId.value = availableParts.first.id;
//         final partSubjects = filteredSubjects;
//         if (partSubjects.isNotEmpty) {
//           selectedSubjectId.value = partSubjects.first.id;
//           final unitsList = curriculumManager.getUnitsForSemester(
//             selectedStageId.value!,
//             selectedSubjectId.value!,
//             selectedSemesterId.value!,
//           );
//           if (unitsList != null && unitsList.isNotEmpty) {
//             selectedUnitId.value = unitsList.first.id;
//           }
//         }
//       }
//     }
//   }

//   List<Stage> get stages => curriculumManager.getAllStages();

//   List<Subject> get subjects {
//     if (selectedStageId.value == null) return [];
//     return curriculumManager.getSubjectsForStage(selectedStageId.value!) ?? [];
//   }

//   List<Semester> get parts {
//     if (selectedStageId.value == null) return [];
//     final allSubjects = subjects;
//     final partsMap = <String, Semester>{};
//     for (final subject in allSubjects) {
//       final semester = subject.semesters.isNotEmpty ? subject.semesters.first : null;
//       if (semester != null) {
//         partsMap[semester.id] = semester;
//       }
//     }
//     return partsMap.values.toList();
//   }

//   List<Subject> get filteredSubjects {
//     if (selectedStageId.value == null) return [];
//     if (selectedSemesterId.value == null) return subjects;
//     return subjects.where((subject) {
//       final semester = subject.semesters.isNotEmpty ? subject.semesters.first : null;
//       return semester?.id == selectedSemesterId.value;
//     }).toList();
//   }

//   List<Unit> get units {
//     if (selectedStageId.value == null ||
//         selectedSubjectId.value == null ||
//         selectedSemesterId.value == null) {
//       return [];
//     }
//     return curriculumManager.getUnitsForSemester(
//           selectedStageId.value!,
//           selectedSubjectId.value!,
//           selectedSemesterId.value!,
//         ) ??
//         [];
//   }

//   Stage? get selectedStage {
//     if (selectedStageId.value == null) return null;
//     return stages.firstWhereOrNull((s) => s.id == selectedStageId.value);
//   }

//   Subject? get selectedSubject {
//     if (selectedSubjectId.value == null) return null;
//     return subjects.firstWhereOrNull((s) => s.id == selectedSubjectId.value);
//   }

//   Semester? get selectedSemester {
//     if (selectedSemesterId.value == null) return null;
//     return parts.firstWhereOrNull((s) => s.id == selectedSemesterId.value);
//   }

//   Unit? get selectedUnit {
//     if (selectedUnitId.value == null) return null;
//     return units.firstWhereOrNull((u) => u.id == selectedUnitId.value);
//   }

//   void selectStage(String id) {
//     if (selectedStageId.value == id) return;
//     selectedStageId.value = id;
//     selectedSubjectId.value = null;
//     selectedSemesterId.value = null;
//     selectedUnitId.value = null;

//     final availableParts = parts;
//     if (availableParts.isNotEmpty) {
//       selectedSemesterId.value = availableParts.first.id;
//       final partSubjects = filteredSubjects;
//       if (partSubjects.isNotEmpty) {
//         selectedSubjectId.value = partSubjects.first.id;
//         final allUnits = curriculumManager.getUnitsForSemester(
//           selectedStageId.value!,
//           selectedSubjectId.value!,
//           selectedSemesterId.value!,
//         );
//         if (allUnits != null && allUnits.isNotEmpty) {
//           selectedUnitId.value = allUnits.first.id;
//         }
//       }
//     }
//   }

//   void selectSubject(String id) {
//     if (selectedSubjectId.value == id) return;
//     selectedSubjectId.value = id;
//     selectedUnitId.value = null;

//     final selectedSubject = this.selectedSubject;
//     if (selectedSubject != null && selectedSubject.semesters.isNotEmpty) {
//       selectedSemesterId.value = selectedSubject.semesters.first.id;
//       final allUnits = curriculumManager.getUnitsForSemester(
//         selectedStageId.value!,
//         selectedSubjectId.value!,
//         selectedSemesterId.value!,
//       );
//       if (allUnits != null && allUnits.isNotEmpty) {
//         selectedUnitId.value = allUnits.first.id;
//       }
//     }
//   }

//   void selectPart(String id) {
//     if (selectedSemesterId.value == id) return;
//     selectedSemesterId.value = id;
//     selectedSubjectId.value = null;
//     selectedUnitId.value = null;

//     final partSubjects = filteredSubjects;
//     if (partSubjects.isNotEmpty) {
//       selectedSubjectId.value = partSubjects.first.id;
//       final allUnits = curriculumManager.getUnitsForSemester(
//         selectedStageId.value!,
//         selectedSubjectId.value!,
//         selectedSemesterId.value!,
//       );
//       if (allUnits != null && allUnits.isNotEmpty) {
//         selectedUnitId.value = allUnits.first.id;
//       }
//     }
//   }

//   void selectUnit(String id) {
//     selectedUnitId.value = id;
//   }

//   Future<void> startQuiz() async {
//     if (selectedStageId.value == null ||
//         selectedSubjectId.value == null ||
//         selectedSemesterId.value == null ||
//         selectedUnitId.value == null) {
//       return;
//     }

//     await Get.to(() => AiQuizScreen(
//           stageId: selectedStageId.value!,
//           subjectId: selectedSubjectId.value!,
//           semesterId: selectedSemesterId.value!,
//           unitId: selectedUnitId.value!,
//           curriculumManager: curriculumManager,
//           questionGenerator: questionGenerator,
//           questionCount: questionCount.value,
//           difficulty: selectedDifficulty.value,
//         ));
//   }
// }
// import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import '../../models.dart';
import '../ai_quiz/ai_quiz_screen.dart';

class AiQuizSetupController extends GetxController {
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;

  final selectedStageId = RxnString();
  final selectedSemesterId = RxnString();
  final selectedSubjectId = RxnString();
  final selectedUnitId = RxnString();

  final questionCount = 10.obs;
  final selectedDifficulty = 'easy'.obs;

  AiQuizSetupController({
    CurriculumManager? curriculumManager,
    EnhancedQuestionGenerator? questionGenerator,
  })  : curriculumManager = curriculumManager ?? CurriculumManager(),
        questionGenerator = questionGenerator ?? EnhancedQuestionGenerator();

  @override
  void onInit() {
    super.onInit();
    _loadCurriculumData();
  }

  // =========================
  // تحميل البيانات
  // =========================
  Future<void> _loadCurriculumData() async {
    try {
      final jsonString = await rootBundle
          .loadString('lib/ai_services/sample_curriculum.json');

      await curriculumManager.loadCurriculumFromJson(jsonString);

      _initializeSelection();
    } catch (e) {
      print('Error loading curriculum data: $e');
    }
  }

  // =========================
  // تهيئة القيم الافتراضية
  // =========================
  void _initializeSelection() {
    final stageList = curriculumManager.getAllStages();

    if (stageList.isEmpty) return;

    final stage = stageList.first;
    selectedStageId.value = stage.id;

    if (stage.semesters.isEmpty) return;

    final semester = stage.semesters.first;
    selectedSemesterId.value = semester.id;

    if (semester.subjects.isEmpty) return;

    final subject = semester.subjects.first;
    selectedSubjectId.value = subject.id;

    if (subject.units.isEmpty) return;

    selectedUnitId.value = subject.units.first.id;
  }

  // =========================
  // Getters
  // =========================

  List<Stage> get stages => curriculumManager.getAllStages();

  Stage? get selectedStage =>
      stages.firstWhereOrNull((s) => s.id == selectedStageId.value);

  List<Semester> get semesters =>
      selectedStage?.semesters ?? [];

  Semester? get selectedSemester =>
      semesters.firstWhereOrNull((s) => s.id == selectedSemesterId.value);

  List<Subject> get subjects =>
      selectedSemester?.subjects ?? [];

  Subject? get selectedSubject =>
      subjects.firstWhereOrNull((s) => s.id == selectedSubjectId.value);

  List<Unit> get units =>
      selectedSubject?.units ?? [];

  Unit? get selectedUnit =>
      units.firstWhereOrNull((u) => u.id == selectedUnitId.value);

  // =========================
  // Actions
  // =========================

  void selectStage(String id) {
    if (selectedStageId.value == id) return;

    final stage = stages.firstWhere((s) => s.id == id);

    selectedStageId.value = id;

    if (stage.semesters.isEmpty) {
      selectedSemesterId.value = null;
      selectedSubjectId.value = null;
      selectedUnitId.value = null;
      return;
    }

    final semester = stage.semesters.first;
    selectedSemesterId.value = semester.id;

    if (semester.subjects.isEmpty) {
      selectedSubjectId.value = null;
      selectedUnitId.value = null;
      return;
    }

    final subject = semester.subjects.first;
    selectedSubjectId.value = subject.id;

    selectedUnitId.value =
        subject.units.isNotEmpty ? subject.units.first.id : null;
  }

  void selectSemester(String id) {
    if (selectedSemesterId.value == id) return;

    final semester = semesters.firstWhere((s) => s.id == id);

    selectedSemesterId.value = id;

    if (semester.subjects.isEmpty) {
      selectedSubjectId.value = null;
      selectedUnitId.value = null;
      return;
    }

    final subject = semester.subjects.first;
    selectedSubjectId.value = subject.id;

    selectedUnitId.value =
        subject.units.isNotEmpty ? subject.units.first.id : null;
  }

  void selectSubject(String id) {
    if (selectedSubjectId.value == id) return;

    final subject = subjects.firstWhere((s) => s.id == id);

    selectedSubjectId.value = id;

    selectedUnitId.value =
        subject.units.isNotEmpty ? subject.units.first.id : null;
  }

  void selectUnit(String id) {
    selectedUnitId.value = id;
  }

  // =========================
  // بدء الاختبار
  // =========================

  Future<void> startQuiz() async {
    if (selectedStageId.value == null ||
        selectedSemesterId.value == null ||
        selectedSubjectId.value == null ||
        selectedUnitId.value == null) {
      return;
    }

    await Get.to(() => AiQuizScreen(
          stageId: selectedStageId.value!,
          semesterId: selectedSemesterId.value!,
          subjectId: selectedSubjectId.value!,
          unitId: selectedUnitId.value!,
          curriculumManager: curriculumManager,
          questionGenerator: questionGenerator,
          questionCount: questionCount.value,
          difficulty: selectedDifficulty.value,
        ));
  }
}