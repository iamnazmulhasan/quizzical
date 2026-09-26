import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/core/utils/loader_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/assets.dart';
import '../../../../di_container.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/dropdown_item_widget.dart';

class QuizConfigPage extends StatefulWidget {
  const QuizConfigPage({super.key});

  @override
  State<QuizConfigPage> createState() => _QuizConfigPageState();
}

class _QuizConfigPageState extends State<QuizConfigPage> {
  final QuizController controller = Get.find<QuizController>();

  // Local reactive states (default amount: 10 as specified in requirements)
  final RxInt numQuestions = 10.obs;
  final RxString difficulty = 'any'.obs;
  final RxString type = 'any'.obs;

  late int categoryId;
  late String categoryName;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    categoryId = args?['categoryId'] ?? 0;
    categoryName = args?['categoryName'] ?? "Category";

    _loadSavedConfig();
  }

  void _loadSavedConfig() {
    if (sl.isRegistered<SharedPreferences>()) {
      final prefs = sl<SharedPreferences>();
      numQuestions.value = prefs.getInt('pref_quiz_amount') ?? 10;
      difficulty.value = prefs.getString('pref_quiz_difficulty') ?? 'any';
      type.value = prefs.getString('pref_quiz_type') ?? 'any';
    }
  }

  Future<void> _startQuiz() async {
    if (controller.isLoading.value) return;

    // Save preferences for replay
    if (sl.isRegistered<SharedPreferences>()) {
      final prefs = sl<SharedPreferences>();
      await prefs.setInt('pref_quiz_amount', numQuestions.value);
      await prefs.setString('pref_quiz_difficulty', difficulty.value);
      await prefs.setString('pref_quiz_type', type.value);
    }

    // Show blocking loader
    Get.dialog(
      LoaderUtil.showBeautifulLoader(Colors.white),
      barrierDismissible: false,
    );

    try {
      await controller.loadQuizList(
        amount: numQuestions.value,
        categoryId: categoryId,
        difficulty: difficulty.value,
        type: type.value,
      );
      if (Get.isDialogOpen == true) Get.back();
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Illustration
              Center(
                child: Image.asset(
                  Assets.assetImages.splashLogo,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // Title, Subtitle, Category
              Center(
                child: Column(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.heading1.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppConstants.configPageSubtitle,
                      style: AppTextStyles.heading1SubTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Number of Questions
                      Text('Number of Questions', style: AppTextStyles.catTitle),
                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select 1–50", style: AppTextStyles.bodySmall),
                          Obx(() => Text(
                            "${numQuestions.value}",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF1E9AE6),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),

                      Obx(
                        () => SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF1E9AE6),
                            inactiveTrackColor: Colors.grey.shade300,
                            trackHeight: 6,
                            thumbColor: const Color(0xFF1E9AE6),
                          ),
                          child: Slider(
                            min: 1,
                            max: 50,
                            divisions: 49,
                            value: numQuestions.value.toDouble(),
                            onChanged: (v) => numQuestions.value = v.round(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Difficulty
                      Text('Difficulty Level', style: AppTextStyles.catTitle),
                      const SizedBox(height: 6),

                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: difficulty.value,
                              isExpanded: true,
                              items: [
                                dropDownItemWidget("any", "Any Difficulty"),
                                dropDownItemWidget("easy", "Easy"),
                                dropDownItemWidget("medium", "Medium"),
                                dropDownItemWidget("hard", "Hard"),
                              ],
                              onChanged: (v) => difficulty.value = v ?? 'any',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Question Type
                      Text('Question Type', style: AppTextStyles.catTitle),
                      const SizedBox(height: 6),

                      Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: type.value,
                              isExpanded: true,
                              items: [
                                dropDownItemWidget("any", "Any Type"),
                                dropDownItemWidget("multiple", "Multiple Choice"),
                                dropDownItemWidget("boolean", "True / False"),
                              ],
                              onChanged: (v) => type.value = v ?? 'any',
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // START Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  return OutlinedButton(
                    onPressed: controller.isLoading.value ? null : _startQuiz,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: controller.isLoading.value
                            ? Colors.grey.shade400
                            : AppColors.nextBtnBgColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'START',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: controller.isLoading.value
                            ? Colors.grey.shade400
                            : AppColors.nextBtnBgColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
