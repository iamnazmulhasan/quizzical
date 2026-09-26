import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../controllers/quiz_play_controller.dart';
import '../widgets/empty_radio_widget.dart';
import '../widgets/exit_quiz_dialogue.dart';
import '../widgets/option_tile_widget.dart';
import '../widgets/result_circle_widget.dart';

class QuizPlayPage extends StatelessWidget {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizPlayController ctrl = Get.put(QuizPlayController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            ctrl.pauseTimers();
            final exit = await Get.dialog<bool>(
              const ExitQuizDialog(),
              barrierDismissible: false,
            );
            if (exit == true) {
              Get.offAllNamed(AppPages.categories);
            } else {
              ctrl.resumeTimers();
            }
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              // Linear Progress Bar at top
              Obx(() {
                return LinearProgressIndicator(
                  value: ctrl.progressPercentage,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E9AE6)),
                  minHeight: 5,
                );
              }),

              // Top Bar with Timer, Progress Counter, and EXIT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Timer indicator
                    Obx(() {
                      final seconds = ctrl.remainingSeconds.value;
                      final isLow = seconds <= 5;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLow ? Colors.red.shade100 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isLow ? Colors.red : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: isLow ? Colors.red : AppColors.nextBtnBgColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${seconds}s',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isLow ? Colors.red : AppColors.nextBtnBgColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Question counter (e.g. 7/10)
                    Obx(() => Text(
                      ctrl.progressText,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),

                    // Exit Button
                    InkWell(
                      onTap: () async {
                        ctrl.pauseTimers();
                        final shouldExit = await Get.dialog<bool>(
                          const ExitQuizDialog(),
                          barrierDismissible: false,
                        );
                        if (shouldExit == true) {
                          Get.offAllNamed(AppPages.categories);
                        } else {
                          ctrl.resumeTimers();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'EXIT',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            Assets.assetIcons.logout,
                            width: 22,
                            height: 22,
                            color: Colors.black87,
                            errorBuilder: (c, e, s) => const Icon(
                              Icons.logout,
                              size: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Question Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final q = ctrl.currentQuestion;
                  return Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 120),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        q.question,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Answer Options List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    final options = ctrl.currentOptions;
                    final selected = ctrl.selectedAnswer.value;
                    final showing = ctrl.showFeedback.value;
                    final correct = ctrl.currentQuestion.correctAnswer;

                    return ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final opt = options[i];
                        final isSelected =
                            ctrl.normalize(selected) == ctrl.normalize(opt);
                        final isCorrect =
                            ctrl.normalize(opt) == ctrl.normalize(correct);

                        Color bg = Colors.white;
                        Widget indicator = const EmptyRadioWidget();

                        if (showing) {
                          if (isCorrect) {
                            bg = AppColors.rightAnsBgColor;
                            indicator = const ResultCircleWidget(
                              color: AppColors.nextBtnBgColor,
                              icon: Icons.check,
                              iconColor: Colors.white,
                            );
                          } else if (isSelected && !isCorrect) {
                            bg = AppColors.wrongAnsBgColor;
                            indicator = const ResultCircleWidget(
                              color: Colors.red,
                              icon: Icons.close,
                              iconColor: Colors.white,
                            );
                          }
                        }

                        return OptionTileWidget(
                          text: opt,
                          backgroundColor: bg,
                          trailing: indicator,
                          onTap: () {
                            if (!showing) ctrl.submitAnswer(opt);
                          },
                        );
                      },
                    );
                  }),
                ),
              ),

              // Bottom CTA: Next / Finish
              Obx(() {
                final canTap = ctrl.showFeedback.value;
                final isLast = ctrl.currentIndex.value >= ctrl.questions.length - 1;
                return PrimaryButtonWidget(
                  title: isLast ? "Finish" : "Next",
                  onPressed: canTap ? ctrl.next : null,
                  isEnabled: canTap,
                  height: 55,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
