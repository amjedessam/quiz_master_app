import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import '../../models.dart';
import '../ai_quiz/ai_quiz_screen.dart';

class AiQuizSetupController extends GetxController {
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;

  final selectedPart = 1.obs; // أو RxInt
  final selectedStageId = RxnString();
  final selectedSubjectId = RxnString();
  final selectedSemesterId = RxnString();
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

  Future<void> _loadCurriculumData() async {
    try {
      // Load curriculum data from JSON file
      final jsonString = await rootBundle.loadString('lib/ai_services/sample_curriculum.json');
      await curriculumManager.loadCurriculumFromJson(jsonString);
      _initializeSelection();
    } catch (e) {
      print('Error loading curriculum data: $e');
      // Fallback to empty selection
    }
  }

  void _initializeSelection() {
    final stages = curriculumManager.getAllStages();
    if (stages.isNotEmpty) {
      selectedStageId.value = stages.first.id;
      final subjects = curriculumManager.getSubjectsForStage(stages.first.id);
      if (subjects != null && subjects.isNotEmpty) {
        selectedSubjectId.value = subjects.first.id;
        final semesters = curriculumManager.getSemestersForSubject(stages.first.id, subjects.first.id);
        if (semesters != null && semesters.isNotEmpty) {
          selectedSemesterId.value = semesters.first.id;
          final units = curriculumManager.getUnitsForSemester(stages.first.id, subjects.first.id, semesters.first.id);
          if (units != null && units.isNotEmpty) {
            selectedUnitId.value = units.first.id;
          }
        }
      }
    }
  }

  List<Stage> get stages => curriculumManager.getAllStages();

  List<Subject> get subjects {
    if (selectedStageId.value == null) return [];
    return curriculumManager.getSubjectsForStage(selectedStageId.value!) ?? [];
  }

  List<Semester> get semesters {
    if (selectedStageId.value == null || selectedSubjectId.value == null) return [];
    return curriculumManager.getSemestersForSubject(selectedStageId.value!, selectedSubjectId.value!) ?? [];
  }

  List<Unit> get units {
    if (selectedStageId.value == null ||
        selectedSubjectId.value == null ||
        selectedSemesterId.value == null) {
      return [];
    }
    return curriculumManager.getUnitsForSemester(
          selectedStageId.value!,
          selectedSubjectId.value!,
          selectedSemesterId.value!,
        ) ??
        [];
  }

  Stage? get selectedStage {
    if (selectedStageId.value == null) return null;
    return stages.firstWhereOrNull((s) => s.id == selectedStageId.value);
  }

  Subject? get selectedSubject {
    if (selectedSubjectId.value == null) return null;
    return subjects.firstWhereOrNull((s) => s.id == selectedSubjectId.value);
  }

  Semester? get selectedSemester {
    if (selectedSemesterId.value == null) return null;
    return semesters.firstWhereOrNull((s) => s.id == selectedSemesterId.value);
  }

  Unit? get selectedUnit {
    if (selectedUnitId.value == null) return null;
    return units.firstWhereOrNull((u) => u.id == selectedUnitId.value);
  }

  void selectStage(String id) {
    if (selectedStageId.value == id) return;
    selectedStageId.value = id;
    selectedSubjectId.value = null;
    selectedSemesterId.value = null;
    selectedUnitId.value = null;

    final allSubjects = subjects;
    if (allSubjects.isNotEmpty) {
      selectedSubjectId.value = allSubjects.first.id;
      final allSemesters = semesters;
      if (allSemesters.isNotEmpty) {
        selectedSemesterId.value = allSemesters.first.id;
        final allUnits = units;
        if (allUnits.isNotEmpty) {
          selectedUnitId.value = allUnits.first.id;
        }
      }
    }
  }

  void selectSubject(String id) {
    if (selectedSubjectId.value == id) return;
    selectedSubjectId.value = id;
    selectedSemesterId.value = null;
    selectedUnitId.value = null;

    final allSemesters = semesters;
    if (allSemesters.isNotEmpty) {
      selectedSemesterId.value = allSemesters.first.id;
      final allUnits = units;
      if (allUnits.isNotEmpty) {
        selectedUnitId.value = allUnits.first.id;
      }
    }
  }

  void selectSemester(String id) {
    if (selectedSemesterId.value == id) return;
    selectedSemesterId.value = id;
    selectedUnitId.value = null;

    final allUnits = units;
    if (allUnits.isNotEmpty) {
      selectedUnitId.value = allUnits.first.id;
    }
  }

  void selectUnit(String id) {
    selectedUnitId.value = id;
  }

  Future<void> startQuiz() async {
    if (selectedStageId.value == null ||
        selectedSubjectId.value == null ||
        selectedSemesterId.value == null ||
        selectedUnitId.value == null) {
      return;
    }

    await Get.to(() => AiQuizScreen(
          stageId: selectedStageId.value!,
          subjectId: selectedSubjectId.value!,
          semesterId: selectedSemesterId.value!,
          unitId: selectedUnitId.value!,
          curriculumManager: curriculumManager,
          questionGenerator: questionGenerator,
          questionCount: questionCount.value,
          difficulty: selectedDifficulty.value,
        ));
  }
}
