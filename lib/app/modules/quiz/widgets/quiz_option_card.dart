import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class QuizOptionCard extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback onTap;

  const QuizOptionCard({
    super.key,
    required this.option,
    required this.text,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.border;
    Color bgColor = Colors.white;
    Color textColor = AppColors.textPrimary;

    if (isSelected && isCorrect == null) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.1);
      textColor = AppColors.primary;
    }

    if (isCorrect != null) {
      if (isCorrect!) {
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
      } else if (isSelected) {
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
      }
    }

    return InkWell(
      onTap: isCorrect == null ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? borderColor : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),

            if (isCorrect != null) ...[
              const SizedBox(width: 8),
              Icon(
                isCorrect! ? Icons.check_circle : Icons.cancel,
                color: isCorrect! ? AppColors.success : AppColors.error,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
