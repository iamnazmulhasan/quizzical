import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

class ScoreBadge extends StatelessWidget {
  final int percentage;
  const ScoreBadge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final bool isHighScore = percentage >= 60;
    final Color outerColor = isHighScore
        ? AppColors.resultScoreOuterColor
        : AppColors.lowScoreOuterColor;
    final Color innerColor = isHighScore
        ? AppColors.resultScoreInnerColor
        : AppColors.lowScoreInnerColor;
    final Color textColor = isHighScore
        ? AppColors.categoryTitlePrimary
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: outerColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: outerColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            decoration: BoxDecoration(
              color: innerColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: AppTextStyles.heading1.copyWith(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}