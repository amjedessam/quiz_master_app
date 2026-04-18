import 'package:flutter/material.dart';
import '../models.dart';

/// Question Widget Display
class QuestionDisplay extends StatefulWidget {
  final dynamic question; // Can be any question type
  final int questionNumber;
  final int totalQuestions;
  final Function(String answer) onAnswered;

  const QuestionDisplay({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswered,
  }) : super(key: key);

  @override
  State<QuestionDisplay> createState() => _QuestionDisplayState();
}

class _QuestionDisplayState extends State<QuestionDisplay> {
  String? selectedAnswer;
  List<String> selectedAnswers = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السؤال ${widget.questionNumber} من ${widget.totalQuestions}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${((widget.questionNumber / widget.totalQuestions) * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.blue[700],
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: widget.questionNumber / widget.totalQuestions,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),

          // Question Content based on type
          if (widget.question is Question)
            _buildMultipleChoiceQuestion(widget.question as Question)
          else if (widget.question is TrueFalseQuestion)
            _buildTrueFalseQuestion(widget.question as TrueFalseQuestion)
          else if (widget.question is FillInTheBlanksQuestion)
            _buildFillInBlanksQuestion(widget.question as FillInTheBlanksQuestion)
          else if (widget.question is MultiSelectQuestion)
            _buildMultiSelectQuestion(widget.question as MultiSelectQuestion)
          else if (widget.question is ShortAnswerQuestion)
            _buildShortAnswerQuestion(widget.question as ShortAnswerQuestion),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceQuestion(Question q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        ...q.options.map((option) {
          final isSelected = selectedAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAnswer = option;
                });
                widget.onAnswered(option);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? Colors.blue[50] : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                          width: 2,
                        ),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, color: Colors.white, size: 14),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(option)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTrueFalseQuestion(TrueFalseQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildTrueFalseButton(true, 'صحيح'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTrueFalseButton(false, 'خطأ'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrueFalseButton(bool value, String label) {
    final isSelected = selectedAnswer == value.toString();
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = value.toString();
        });
        widget.onAnswered(value.toString());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue[50] : Colors.white,
        ),
        child: Column(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.cancel,
              color: isSelected ? Colors.blue : Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFillInBlanksQuestion(FillInTheBlanksQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            widget.onAnswered(value);
          },
          decoration: InputDecoration(
            hintText: 'أدخل الإجابة هنا',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectQuestion(MultiSelectQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'اختر جميع الخيارات الصحيحة',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 20),
        ...q.options.map((option) {
          final isSelected = selectedAnswers.contains(option);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedAnswers.remove(option);
                  } else {
                    selectedAnswers.add(option);
                  }
                });
                widget.onAnswered(selectedAnswers.join(','));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? Colors.blue[50] : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, color: Colors.white, size: 14),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(option)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildShortAnswerQuestion(ShortAnswerQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          q.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) {
            widget.onAnswered(value);
          },
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'اكتب إجابتك هنا',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
