import 'package:flutter/material.dart';
import '../models.dart';
import '../curriculum_manager.dart';

/// Curriculum Selection Screen
class CurriculumSelectionScreen extends StatefulWidget {
  final CurriculumManager curriculumManager;
  final Function(String stageId, String subjectId, String semesterId, String unitId) onUnitSelected;

  const CurriculumSelectionScreen({
    Key? key,
    required this.curriculumManager,
    required this.onUnitSelected,
  }) : super(key: key);

  @override
  State<CurriculumSelectionScreen> createState() => _CurriculumSelectionScreenState();
}

class _CurriculumSelectionScreenState extends State<CurriculumSelectionScreen> {
  late List<Stage> stages;
  String? selectedStageId;
  String? selectedSubjectId;
  String? selectedSemesterId;
  String? selectedUnitId;

  @override
  void initState() {
    super.initState();
    stages = widget.curriculumManager.getAllStages();
    if (stages.isNotEmpty) {
      selectedStageId = stages.first.id;
      selectedSubjectId = stages.first.subjects.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('اختر المنهج الدراسي')),
        body: Center(
          child: Text('لا توجد مناهج متاحة'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر المنهج الدراسي'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stage Selection
          Text('المرحلة الدراسية', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedStageId,
              underline: const SizedBox(),
              items: stages.map((stage) {
                return DropdownMenuItem(
                  value: stage.id,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(stage.name),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedStageId = value;
                    selectedSubjectId = stages.firstWhere((s) => s.id == value).subjects.first.id;
                    selectedSemesterId = null;
                    selectedUnitId = null;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 24),

          // Subject Selection
          if (selectedStageId != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المادة الدراسية', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSubjectId,
                    underline: const SizedBox(),
                    items: widget.curriculumManager
                            .getSubjectsForStage(selectedStageId!)
                            ?.map((subject) {
                          return DropdownMenuItem(
                            value: subject.id,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(subject.icon, style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 12),
                                  Text(subject.name),
                                ],
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSubjectId = value;
                          selectedSemesterId = null;
                          selectedUnitId = null;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Semester Selection
                if (selectedSubjectId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الفصل الدراسي', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedSemesterId,
                          underline: const SizedBox(),
                          items: widget.curriculumManager
                                  .getSemestersForSubject(selectedStageId!, selectedSubjectId!)
                                  ?.map((semester) {
                                return DropdownMenuItem(
                                  value: semester.id,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(semester.name),
                                  ),
                                );
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedSemesterId = value;
                                selectedUnitId = null;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Unit Selection (as cards)
                      if (selectedSemesterId != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الوحدات', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            ...(widget.curriculumManager.getUnitsForSemester(
                                    selectedStageId!, selectedSubjectId!, selectedSemesterId!) ??
                                [])
                                .map((unit) {
                              final isSelected = selectedUnitId == unit.id;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedUnitId = unit.id;
                                  });
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  color: isSelected ? Colors.blue[50] : Colors.white,
                                  elevation: isSelected ? 4 : 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          unit.name,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.blue : Colors.black,
                                              ),
                                        ),
                                        if (unit.description?.isNotEmpty ?? false) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            unit.description!,
                                            style: Theme.of(context).textTheme.bodySmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Text(
                                          '${unit.lessons.length} دروس',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          const SizedBox(height: 24),

          // Start Quiz Button
          if (selectedUnitId != null)
            ElevatedButton.icon(
              onPressed: () {
                widget.onUnitSelected(
                  selectedStageId!,
                  selectedSubjectId!,
                  selectedSemesterId!,
                  selectedUnitId!,
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.quiz),
              label: const Text('ابدأ الاختبار'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
        ],
      ),
    );
  }
}
