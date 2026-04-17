import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models.dart';
import '../question_generator_enhanced.dart';
import '../curriculum_manager.dart';
import 'question_widget.dart';
import 'quiz_result_screen.dart';

/// Interactive Quiz Screen
class QuizScreen extends StatefulWidget {
  final String stageId;
  final String subjectId;
  final String semesterId;
  final String unitId;
  final CurriculumManager curriculumManager;
  final EnhancedQuestionGenerator questionGenerator;

  const QuizScreen({
    Key? key,
    required this.stageId,
    required this.subjectId,
    required this.semesterId,
    required this.unitId,
    required this.curriculumManager,
    required this.questionGenerator,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  List<dynamic> questions = [];
  List<String> userAnswers = [];
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final unit = widget.curriculumManager.getUnitsForSemester(
        widget.stageId,
        widget.subjectId,
        widget.semesterId,
      )?.firstWhere((u) => u.id == widget.unitId);

      if (unit == null) {
        setState(() {
          errorMessage = 'لم يتم العثور على الوحدة';
          isLoading = false;
        });
        return;
      }

      final topic = unit.name;
      final context = widget.curriculumManager.generateQuizContext(
        widget.stageId,
        widget.subjectId,
        widget.semesterId,
        widget.unitId,
      );

      // Generate varied questions
      final variedQuestions = await widget.questionGenerator.generateVariedQuestions(
        topic,
        context,
        10, // Total questions
      );

      // Mix all question types
      final allQuestions = <dynamic>[
        ...(variedQuestions['multipleChoice'] as List? ?? []),
        ...(variedQuestions['trueFalse'] as List? ?? []),
        ...(variedQuestions['fillInBlanks'] as List? ?? []),
        ...(variedQuestions['shortAnswer'] as List? ?? []),
      ];

      setState(() {
        questions = allQuestions;
        userAnswers = List.filled(allQuestions.length, '');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ في تحميل الأسئلة: $e';
        isLoading = false;
      });
    }
  }

  void _nextQuestion() {
    if (currentPage < questions.length - 1) {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitQuiz() {
    // Calculate score
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_isAnswerCorrect(questions[i], userAnswers[i])) {
        correctAnswers++;
      }
    }

    // Create quiz result
    final quizResult = QuizResult(
      quizId: '${widget.unitId}_${DateTime.now().millisecondsSinceEpoch}',
      studentId: 'student_123', // Replace with actual student ID
      completedAt: DateTime.now(),
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      timeTaken: Duration(minutes: 5), // Track actual time
      results: List.generate(
        questions.length,
        (index) => QuestionResult(
          questionId: '${index}_${questions[index].toString().hashCode}',
          userAnswer: userAnswers[index],
          isCorrect: _isAnswerCorrect(questions[index], userAnswers[index]),
          timeSpent: const Duration(seconds: 30), // Track actual time per question
        ),
      ),
    );

    // Navigate to result screen
    Get.off(() => QuizResultScreen(
      quizResult: quizResult,
      onRetry: () {
        setState(() {
          userAnswers = List.filled(questions.length, '');
          currentPage = 0;
        });
        _pageController.jumpToPage(0);
      },
      onBack: () => Navigator.pop(context),
    ));
  }

  bool _isAnswerCorrect(dynamic question, String userAnswer) {
    if (question is Question) {
      return question.correctAnswer == userAnswer;
    } else if (question is TrueFalseQuestion) {
      return question.correctAnswer.toString() == userAnswer;
    } else if (question is FillInTheBlanksQuestion) {
      return question.correctAnswers
          .contains(userAnswer.toLowerCase().trim());
    } else if (question is MultiSelectQuestion) {
      final userAnswersList = userAnswer.split(',');
      return question.correctAnswers.every((ans) => userAnswersList.contains(ans));
    } else if (question is ShortAnswerQuestion) {
      // Simple check - in production use more sophisticated comparison
      return question.acceptableAnswers.any((ans) =>
          userAnswer.toLowerCase().contains(ans.toLowerCase()));
    }
    return false;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هل تريد الخروج؟'),
            content: const Text('سيتم فقدان تقدمك في الاختبار'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('نعم'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الاختبار التفاعلي'),
          elevation: 0,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${currentPage + 1}/${questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(errorMessage!),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });
                            _loadQuestions();
                          },
                          child: const Text('حاول مرة أخرى'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() => currentPage = page);
                          },
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            return QuestionDisplay(
                              question: questions[index],
                              questionNumber: index + 1,
                              totalQuestions: questions.length,
                              onAnswered: (answer) {
                                setState(() {
                                  userAnswers[index] = answer;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: currentPage > 0 ? _previousQuestion : null,
                                    child: const Text('السابق'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: currentPage < questions.length - 1
                                        ? _nextQuestion
                                        : null,
                                    child: const Text('التالي'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (currentPage == questions.length - 1)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _submitQuiz,
                                  icon: const Icon(Icons.check),
                                  label: const Text('إنهاء الاختبار'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
