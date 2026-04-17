import 'package:flutter/material.dart';
import '../models.dart';

/// Quiz Result Screen
class QuizResultScreen extends StatelessWidget {
  final QuizResult quizResult;
  final Function()? onRetry;
  final Function()? onBack;

  const QuizResultScreen({
    Key? key,
    required this.quizResult,
    this.onRetry,
    this.onBack,
  }) : super(key: key);

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceMessage(double score) {
    if (score >= 90) return '🎉 ممتاز جداً!';
    if (score >= 80) return '🎯 ممتاز!';
    if (score >= 70) return '👍 جيد جداً!';
    if (score >= 60) return '✏️ جيد!';
    return '📚 حاول مرة أخرى';
  }

  @override
  Widget build(BuildContext context) {
    final score = quizResult.score;
    final minutesTaken = quizResult.timeTaken.inMinutes;
    final secondsTaken = quizResult.timeTaken.inSeconds % 60;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getScoreColor(score),
                      _getScoreColor(score).withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getPerformanceMessage(score),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Score Display
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'النتيجة النهائية',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScoreCard(
                            title: 'النسبة',
                            value: '${score.toStringAsFixed(1)}%',
                            icon: Icons.assessment,
                          ),
                          _buildScoreCard(
                            title: 'الإجابات الصحيحة',
                            value: '${quizResult.correctAnswers}/${quizResult.totalQuestions}',
                            icon: Icons.check_circle,
                          ),
                          _buildScoreCard(
                            title: 'الوقت المستغرق',
                            value: '$minutesTaken:${secondsTaken.toString().padLeft(2, '0')}',
                            icon: Icons.timer,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Statistics
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الإحصائيات',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatItem(
                        'عدد الأسئلة',
                        '${quizResult.totalQuestions}',
                      ),
                      _buildStatItem(
                        'الإجابات الصحيحة',
                        '${quizResult.correctAnswers}',
                      ),
                      _buildStatItem(
                        'الإجابات الخاطئة',
                        '${quizResult.totalQuestions - quizResult.correctAnswers}',
                      ),
                      _buildStatItem(
                        'معدل النجاح',
                        '${score.toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details
                if (quizResult.results.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفاصيل الإجابات',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizResult.results.length,
                        itemBuilder: (context, index) {
                          final result = quizResult.results[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: result.isCorrect ? Colors.green : Colors.red,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: result.isCorrect
                                    ? Colors.green[50]
                                    : Colors.red[50],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    result.isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: result.isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'السؤال ${index + 1}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        Text(
                                          'إجابتك: ${result.userAnswer}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${result.timeSpent.inSeconds}ث',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('العودة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('حاول مجدداً'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
