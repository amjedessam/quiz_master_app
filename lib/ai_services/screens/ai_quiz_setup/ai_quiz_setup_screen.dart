import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../curriculum_manager.dart';
import '../../question_generator_enhanced.dart';
import '../ai_quiz_setup/ai_quiz_setup_controller.dart';

class AiQuizSetupScreen extends StatefulWidget {
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;
  final int initialQuestionCount;

  const AiQuizSetupScreen({
    Key? key,
    required this.curriculumManager,
    required this.questionGenerator,
    this.initialQuestionCount = 10,
  }) : super(key: key);

  @override
  State<AiQuizSetupScreen> createState() => _AiQuizSetupScreenState();
}

class _AiQuizSetupScreenState extends State<AiQuizSetupScreen> {
  late final AiQuizSetupController _controller;
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'ai_quiz_setup_${DateTime.now().microsecondsSinceEpoch}';
    _controller = Get.put(
      AiQuizSetupController(
        curriculumManager: widget.curriculumManager,
        questionGenerator: widget.questionGenerator,
      ),
      tag: _controllerTag,
    );
    _controller.questionCount.value = widget.initialQuestionCount;
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiQuizSetupController>(tag: _controllerTag)) {
      Get.delete<AiQuizSetupController>(tag: _controllerTag);
    }
    super.dispose();
  }

  AiQuizSetupController get controller => Get.find<AiQuizSetupController>(tag: _controllerTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HintBanner(),
                    const SizedBox(height: 28),
                    _SectionLabel(number: '١', title: 'اختر المستوى'),
                    const SizedBox(height: 14),
                    _buildStageDropdown(context),
                    Obx(() {
                      if (controller.semesters.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          _SectionLabel(number: '٢', title: 'اختر الجزء'),
                          const SizedBox(height: 14),
                          _buildSemesterChips(),
                        ],
                      );
                    }),
                    Obx(() {
                      if (controller.subjects.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          _SectionLabel(number: '٣', title: 'اختر المادة'),
                          const SizedBox(height: 14),
                          _buildSubjectGrid(),
                        ],
                      );
                    }),
                    Obx(() {
                      if (controller.units.isEmpty) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          _SectionLabel(number: '٤', title: 'اختر الوحدة'),
                          const SizedBox(height: 14),
                          _buildUnitList(),
                        ],
                      );
                    }),
                    Obx(() {
                      if (controller.selectedUnitId.value == null) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          _SectionLabel(number: '٥', title: 'إعدادات الاختبار'),
                          const SizedBox(height: 14),
                          _buildOptionsCard(),
                          const SizedBox(height: 28),
                          _buildStartButton(),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C74FF), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          children: const [
            Text(
              'إعداد اختبار الذكاء الاصطناعي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'اختر المادة والوحدة واستعن بخدمة AI لتوليد أسئلة تلقائياً من المنهج.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageDropdown(BuildContext context) {
    return Obx(() {
      final stages = controller.stages;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButton<String>(
          value: controller.selectedStageId.value,
          underline: const SizedBox(),
          isExpanded: true,
          items: stages.map((stage) {
            return DropdownMenuItem(value: stage.id, child: Text(stage.name));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectStage(value);
            }
          },
        ),
      );
    });
  }

  Widget _buildSubjectGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.subjects.map((subject) {
        final bool isSelected = subject.id == controller.selectedSubjectId.value;
        return GestureDetector(
          onTap: () => controller.selectSubject(subject.id),
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 28,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7C74FF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF7C74FF) : Colors.grey[300]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 12),
                Text(
                  subject.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                if (subject.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subject.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSemesterChips() {
    return Obx(() {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: controller.semesters.map((semester) {
          final isSelected = semester.id == controller.selectedSemesterId.value;
          return ChoiceChip(
            label: Text(semester.name),
            selected: isSelected,
            onSelected: (_) => controller.selectSemester(semester.id),
            selectedColor: const Color(0xFF7C74FF),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildUnitList() {
    return Column(
      children: controller.units.map((unit) {
        final isSelected = unit.id == controller.selectedUnitId.value;
        return GestureDetector(
          onTap: () => controller.selectUnit(unit.id),
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: isSelected ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: isSelected ? const Color(0xFFEEE8FF) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF7C74FF) : Colors.black87,
                    ),
                  ),
                  if ((unit.description?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 8),
                    Text(
                      unit.description!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${unit.lessons.length} درس',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'عدد الأسئلة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Obx(() {
            return Slider(
              value: controller.questionCount.value.toDouble(),
              min: 5,
              max: 20,
              divisions: 15,
              label: '${controller.questionCount.value} سؤال',
              onChanged: (value) => controller.questionCount.value = value.toInt(),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'مستوى الصعوبة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['easy', 'medium', 'hard'].map((level) {
                final isSelected = controller.selectedDifficulty.value == level;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectedDifficulty.value = level,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7C74FF) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        level == 'easy' ? 'سهل' : level == 'medium' ? 'متوسط' : 'صعب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.selectedUnitId.value != null ? () => controller.startQuiz() : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text('ابدأ الاختبار', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C74FF), Color(0xFF6C63FF)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'هذه الواجهة تستخدم بيانات المنهج من ملف JSON وستطلب من خدمة الذكاء الاصطناعي توليد الأسئلة تلقائياً بناءً على الوحدة المختارة.',
        style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String number;
  final String title;

  const _SectionLabel({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF7C74FF),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
