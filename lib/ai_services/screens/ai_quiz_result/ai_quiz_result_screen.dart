import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models.dart';
import 'ai_quiz_result_controller.dart';

class AiQuizResultScreen extends StatefulWidget {
  final QuizResult quizResult;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const AiQuizResultScreen({
    Key? key,
    required this.quizResult,
    this.onRetry,
    this.onBack,
  }) : super(key: key);

  @override
  State<AiQuizResultScreen> createState() => _AiQuizResultScreenState();
}

class _AiQuizResultScreenState extends State<AiQuizResultScreen> {
  late final AiQuizResultController _controller;
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    _controllerTag = 'ai_quiz_result_${widget.quizResult.quizId}';
    _controller = Get.put(AiQuizResultController(), tag: _controllerTag);
    _controller.initialize(
      quizResult: widget.quizResult,
      onRetry: widget.onRetry,
      onBack: widget.onBack,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiQuizResultController>(tag: _controllerTag)) {
      Get.delete<AiQuizResultController>(tag: _controllerTag);
    }
    super.dispose();
  }

  AiQuizResultController get controller => Get.find<AiQuizResultController>(tag: _controllerTag);

  Color _scoreColor() {
    if (controller.quizResult.score >= 90) return Colors.green;
    if (controller.quizResult.score >= 75) return Colors.blue;
    if (controller.quizResult.score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _statusMessage() {
    final score = controller.quizResult.score;
    if (score >= 90) return 'ممتاز! 🎉';
    if (score >= 75) return 'أداء قوي 👍';
    if (score >= 60) return 'جيد، واصل التدريب 💪';
    return 'راجع الدروس وحاول مجدداً 📚';
  }

  @override
  Widget build(BuildContext context) {
    final minutes = controller.quizResult.timeTaken.inMinutes;
    final seconds = controller.quizResult.timeTaken.inSeconds % 60;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: controller.onBack ?? () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      _statusMessage(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: _scoreColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildScoreCircle(),
                    const SizedBox(height: 28),
                    _buildSummaryCard(minutes, seconds),
                    const SizedBox(height: 24),
                    _buildPerformanceCards(),
                    const SizedBox(height: 28),
                    _buildAnswerDetails(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.onBack ?? () => Navigator.pop(context),
                      child: const Text('العودة'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.onRetry,
                      child: const Text('حاول مجدداً'),
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

  Widget _buildScoreCircle() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 14,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: controller.quizResult.score / 100,
              strokeWidth: 14,
              color: _scoreColor(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${controller.quizResult.score.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: _scoreColor(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${controller.quizResult.correctAnswers}/${controller.quizResult.totalQuestions} إجابة صحيحة',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int minutes, int seconds) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ملخص الاختبار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('عدد الأسئلة', '${controller.quizResult.totalQuestions}'),
            const SizedBox(height: 10),
            _buildStatRow(
              'الوقت المستغرق',
              '$minutes:${seconds.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 10),
            _buildStatRow('عدد الصحيح', '${controller.quizResult.correctAnswers}'),
            const SizedBox(height: 10),
            _buildStatRow('النسبة', '${controller.quizResult.score.toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCards() {
    final wrong = controller.quizResult.totalQuestions - controller.quizResult.correctAnswers;
    return Row(
      children: [
        _buildMiniCard('صحيح', '${controller.quizResult.correctAnswers}', Colors.green),
        const SizedBox(width: 12),
        _buildMiniCard('خاطئ', '$wrong', Colors.red),
      ],
    );
  }

  Widget _buildMiniCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل الإجابات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.quizResult.results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final result = controller.quizResult.results[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: result.isCorrect ? Colors.green[50] : Colors.red[50],
                border: Border.all(
                  color: result.isCorrect ? Colors.green : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    result.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: result.isCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السؤال ${index + 1} - إجابتك: ${result.userAnswer.isEmpty ? 'لم تُجب' : result.userAnswer}',
                        ),
                        if (!result.isCorrect && result.correctAnswer.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'الإجابة الصحيحة: ${result.correctAnswer}\n شرح: ${result.explanation}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text('${result.timeSpent.inSeconds} ث'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
