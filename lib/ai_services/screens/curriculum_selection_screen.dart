// import 'package:flutter/material.dart';
// import '../models.dart';
// import '../curriculum_manager.dart';

// /// Curriculum Selection Screen
// class CurriculumSelectionScreen extends StatefulWidget {
//   final CurriculumManager curriculumManager;
//   final Function(
//     String stageId,
//     String subjectId,
//     String semesterId,
//     String unitId,
//   )
//   onUnitSelected;

//   const CurriculumSelectionScreen({
//     Key? key,
//     required this.curriculumManager,
//     required this.onUnitSelected,
//   }) : super(key: key);

//   @override
//   State<CurriculumSelectionScreen> createState() =>
//       _CurriculumSelectionScreenState();
// }

// class _CurriculumSelectionScreenState extends State<CurriculumSelectionScreen> {
//   late List<Stage> stages;
//   String? selectedStageId;
//   String? selectedSemesterId;
//   String? selectedSubjectId;
//   String? selectedUnitId;

//   @override
//   void initState() {
//     super.initState();
//     stages = widget.curriculumManager.getAllStages();

//     if (stages.isNotEmpty) {
//       final firstStage = stages.first;
//       selectedStageId = firstStage.id;

//       if (firstStage.semesters.isNotEmpty) {
//         final firstSemester = firstStage.semesters.first;
//         selectedSemesterId = firstSemester.id;

//         if (firstSemester.subjects.isNotEmpty) {
//           final firstSubject = firstSemester.subjects.first;
//           selectedSubjectId = firstSubject.id;

//           if (firstSubject.units.isNotEmpty) {
//             selectedUnitId = firstSubject.units.first.id;
//           }
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (stages.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('اختر المنهج الدراسي')),
//         body: Center(child: Text('لا توجد مناهج متاحة')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('اختر المنهج الدراسي'), elevation: 0),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Stage Selection
//           Text(
//             'المرحلة الدراسية',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 12),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey[300]!),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: DropdownButton<String>(
//               isExpanded: true,
//               value: selectedStageId,
//               underline: const SizedBox(),
//               items: stages.map((stage) {
//                 return DropdownMenuItem(
//                   value: stage.id,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Text(stage.name),
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   final stage = stages.firstWhere((s) => s.id == value);

//                   setState(() {
//                     selectedStageId = value;

//                     if (stage.semesters.isNotEmpty) {
//                       final semester = stage.semesters.first;
//                       selectedSemesterId = semester.id;

//                       if (semester.subjects.isNotEmpty) {
//                         final subject = semester.subjects.first;
//                         selectedSubjectId = subject.id;

//                         if (subject.units.isNotEmpty) {
//                           selectedUnitId = subject.units.first.id;
//                         } else {
//                           selectedUnitId = null;
//                         }
//                       } else {
//                         selectedSubjectId = null;
//                         selectedUnitId = null;
//                       }
//                     } else {
//                       selectedSemesterId = null;
//                       selectedSubjectId = null;
//                       selectedUnitId = null;
//                     }
//                   });
//                 }
//               },
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Subject Selection
//           if (selectedStageId != null)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'المادة الدراسية',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[300]!),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedSubjectId,
//                     underline: const SizedBox(),
//                     items:
//                         widget.curriculumManager
//                             .getSubjectsForStage(selectedStageId!)
//                             ?.map((subject) {
//                               return DropdownMenuItem(
//                                 value: subject.id,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         subject.icon,
//                                         style: const TextStyle(fontSize: 20),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Text(subject.name),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             })
//                             .toList() ??
//                         [],
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           selectedSubjectId = value;
//                           selectedSemesterId = null;
//                           selectedUnitId = null;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Semester Selection
//                 if (selectedSubjectId != null)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'الفصل الدراسي',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 12),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: selectedSemesterId,
//                           underline: const SizedBox(),
//                           items:
//                               widget.curriculumManager
//                                   .getSemestersForSubject(
//                                     selectedStageId!,
//                                     selectedSubjectId!,
//                                   )
//                                   ?.map((semester) {
//                                     return DropdownMenuItem(
//                                       value: semester.id,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: Text(semester.name),
//                                       ),
//                                     );
//                                   })
//                                   .toList() ??
//                               [],
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 selectedSemesterId = value;
//                                 selectedUnitId = null;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Unit Selection (as cards)
//                       if (selectedSemesterId != null)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'الوحدات',
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                             const SizedBox(height: 12),
//                             ...(widget.curriculumManager.getUnitsForSemester(
//                                       selectedStageId!,
//                                       selectedSubjectId!,
//                                       selectedSemesterId!,
//                                     ) ??
//                                     [])
//                                 .map((unit) {
//                                   final isSelected = selectedUnitId == unit.id;
//                                   return GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         selectedUnitId = unit.id;
//                                       });
//                                     },
//                                     child: Card(
//                                       margin: const EdgeInsets.only(bottom: 12),
//                                       color: isSelected
//                                           ? Colors.blue[50]
//                                           : Colors.white,
//                                       elevation: isSelected ? 4 : 1,
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               unit.name,
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .titleSmall
//                                                   ?.copyWith(
//                                                     fontWeight: FontWeight.bold,
//                                                     color: isSelected
//                                                         ? Colors.blue
//                                                         : Colors.black,
//                                                   ),
//                                             ),
//                                             if (unit.description?.isNotEmpty ??
//                                                 false) ...[
//                                               const SizedBox(height: 8),
//                                               Text(
//                                                 unit.description!,
//                                                 style: Theme.of(
//                                                   context,
//                                                 ).textTheme.bodySmall,
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ],
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               '${unit.lessons.length} دروس',
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .labelSmall
//                                                   ?.copyWith(
//                                                     color: Colors.grey[600],
//                                                   ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 })
//                                 .toList(),
//                           ],
//                         ),
//                     ],
//                   ),
//               ],
//             ),
//           const SizedBox(height: 24),

//           // Start Quiz Button
//           if (selectedUnitId != null)
//             ElevatedButton.icon(
//               onPressed: () {
//                 widget.onUnitSelected(
//                   selectedStageId!,
//                   selectedSubjectId!,
//                   selectedSemesterId!,
//                   selectedUnitId!,
//                 );
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.quiz),
//               label: const Text('ابدأ الاختبار'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models.dart';
import '../curriculum_manager.dart';

class CurriculumSelectionScreen extends StatefulWidget {
  final CurriculumManager curriculumManager;
  final Function(
    String stageId,
    String subjectId,
    String semesterId,
    String unitId,
  ) onUnitSelected;

  const CurriculumSelectionScreen({
    Key? key,
    required this.curriculumManager,
    required this.onUnitSelected,
  }) : super(key: key);

  @override
  State<CurriculumSelectionScreen> createState() =>
      _CurriculumSelectionScreenState();
}

class _CurriculumSelectionScreenState
    extends State<CurriculumSelectionScreen> {
  late List<Stage> stages;

  String? selectedStageId;
  String? selectedSemesterId;
  String? selectedSubjectId;
  String? selectedUnitId;

  @override
  void initState() {
    super.initState();
    stages = widget.curriculumManager.getAllStages();

    if (stages.isNotEmpty) {
      final stage = stages.first;
      selectedStageId = stage.id;

      if (stage.semesters.isNotEmpty) {
        final semester = stage.semesters.first;
        selectedSemesterId = semester.id;

        if (semester.subjects.isNotEmpty) {
          final subject = semester.subjects.first;
          selectedSubjectId = subject.id;

          if (subject.units.isNotEmpty) {
            selectedUnitId = subject.units.first.id;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('اختر المنهج الدراسي')),
        body: const Center(child: Text('لا توجد مناهج')),
      );
    }

    final selectedStage = stages.firstWhere(
      (s) => s.id == selectedStageId,
    );

    final semesters = selectedStage.semesters;

    final selectedSemester = semesters.firstWhere(
      (s) => s.id == selectedSemesterId,
      orElse: () => semesters.first,
    );

    final subjects = selectedSemester.subjects;

    final selectedSubject = subjects.firstWhere(
      (s) => s.id == selectedSubjectId,
      orElse: () => subjects.first,
    );

    final units = selectedSubject.units;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر المنهج الدراسي'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =========================
          // المرحلة
          // =========================
          Text('المرحلة الدراسية',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          DropdownButton<String>(
            isExpanded: true,
            value: selectedStageId,
            items: stages.map((stage) {
              return DropdownMenuItem(
                value: stage.id,
                child: Text(stage.name),
              );
            }).toList(),
            onChanged: (value) {
              final stage = stages.firstWhere((s) => s.id == value);

              setState(() {
                selectedStageId = value;

                if (stage.semesters.isNotEmpty) {
                  final sem = stage.semesters.first;
                  selectedSemesterId = sem.id;

                  if (sem.subjects.isNotEmpty) {
                    final sub = sem.subjects.first;
                    selectedSubjectId = sub.id;

                    if (sub.units.isNotEmpty) {
                      selectedUnitId = sub.units.first.id;
                    } else {
                      selectedUnitId = null;
                    }
                  } else {
                    selectedSubjectId = null;
                    selectedUnitId = null;
                  }
                }
              });
            },
          ),

          const SizedBox(height: 20),

          // =========================
          // الفصل
          // =========================
          Text('الفصل الدراسي',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          DropdownButton<String>(
            isExpanded: true,
            value: selectedSemesterId,
            items: semesters.map((sem) {
              return DropdownMenuItem(
                value: sem.id,
                child: Text(sem.name),
              );
            }).toList(),
            onChanged: (value) {
              final sem = semesters.firstWhere((s) => s.id == value);

              setState(() {
                selectedSemesterId = value;

                if (sem.subjects.isNotEmpty) {
                  final sub = sem.subjects.first;
                  selectedSubjectId = sub.id;

                  if (sub.units.isNotEmpty) {
                    selectedUnitId = sub.units.first.id;
                  } else {
                    selectedUnitId = null;
                  }
                } else {
                  selectedSubjectId = null;
                  selectedUnitId = null;
                }
              });
            },
          ),

          const SizedBox(height: 20),

          // =========================
          // المادة
          // =========================
          Text('المادة',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          DropdownButton<String>(
            isExpanded: true,
            value: selectedSubjectId,
            items: subjects.map((sub) {
              return DropdownMenuItem(
                value: sub.id,
                child: Row(
                  children: [
                    Text(sub.icon),
                    const SizedBox(width: 10),
                    Text(sub.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              final sub = subjects.firstWhere((s) => s.id == value);

              setState(() {
                selectedSubjectId = value;

                if (sub.units.isNotEmpty) {
                  selectedUnitId = sub.units.first.id;
                } else {
                  selectedUnitId = null;
                }
              });
            },
          ),

          const SizedBox(height: 20),

          // =========================
          // الوحدات
          // =========================
          Text('الوحدات',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          ...units.map((unit) {
            final isSelected = selectedUnitId == unit.id;

            return Card(
              color: isSelected ? Colors.blue[50] : null,
              child: ListTile(
                title: Text(unit.name),
                subtitle: Text('${unit.lessons.length} دروس'),
                onTap: () {
                  setState(() {
                    selectedUnitId = unit.id;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 20),

          // =========================
          // زر بدء الاختبار
          // =========================
          if (selectedUnitId != null)
            ElevatedButton(
              onPressed: () {
                widget.onUnitSelected(
                  selectedStageId!,
                  selectedSubjectId!,
                  selectedSemesterId!,
                  selectedUnitId!,
                );
                Navigator.pop(context);
              },
              child: const Text('ابدأ الاختبار'),
            ),
        ],
      ),
    );
  }
}