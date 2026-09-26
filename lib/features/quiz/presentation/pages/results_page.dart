import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../widgets/score_badge_widget.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  int _percentage(int score, int total) {
    final t = max(1, total);
    final p = (score / t) * 100;
    return p.round();
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return "${seconds}s";
    }
    final int minutes = seconds ~/ 60;
    final int remainingSec = seconds % 60;
    return "${minutes}m ${remainingSec}s";
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final int score = args?["score"] ?? 0;
    final int total = args?["total"] ?? 1;
    final int totalTime = args?["totalTime"] ?? 0;

    final percent = _percentage(score, total);
    final bool isHighScore = percent >= 60;

    final title = isHighScore ? "Congratulation" : "Keep Trying!";
    final subtitle = isHighScore
        ? "You've got a great foundation. Ready to try a different category?"
        : "Don't give up! Practice makes perfect. Try again to improve your score";

    final illustration = isHighScore
        ? Assets.assetIcons.celebrate
        : Assets.assetImages.splashLogo;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Dynamic Illustration based on score matching Figma
              Center(
                child: Image.asset(
                  illustration,
                  height: 190,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              // Title (Congratulation / Keep Trying!)
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // Prominent Score Badge (Green for >=60%, Orange/Red for <60%)
              ScoreBadge(percentage: percent),

              const SizedBox(height: 16),

              // Detailed Score and Quick Stats
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Score",
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$score / $total",
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.nextBtnBgColor,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 32, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        Text(
                          "Accuracy",
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$percent%",
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isHighScore ? const Color(0xFF2E7D32) : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 32, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        Text(
                          "Total Time",
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDuration(totalTime),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description subtitle from Figma
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(),

              // Play Again Button (resets state, preserves config via SharedPreferences)
              PrimaryButtonWidget(
                title: "PLAY AGAIN",
                onPressed: () => Get.offAllNamed(AppPages.categories),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
