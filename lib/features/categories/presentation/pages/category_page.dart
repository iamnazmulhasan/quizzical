import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/loader_util.dart';
import '../controllers/category_controller.dart';
import '../widgets/category_card_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController controller = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    controller.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 4, left: 2),
              child: Text(AppConstants.appName, style: AppTextStyles.heading1),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 2),
              child: Text(
                AppConstants.appNameSubTitle,
                style: AppTextStyles.heading1SubTitle,
              ),
            ),

            // Retry Banner if error occurred
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.getCategoryList(forceRefresh: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Retry', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Grid Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return LoaderUtil.showBeautifulLoader();
                }

                final categories = controller.categoryList ?? [];

                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category_outlined, size: 56, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No categories available',
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.getCategoryList(forceRefresh: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.nextBtnBgColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reload'),
                        ),
                      ],
                    ),
                  );
                }

                // Responsive grid calculation
                final width = MediaQuery.of(context).size.width;
                final crossAxis = width > 900 ? 4 : (width > 600 ? 3 : 2);

                return RefreshIndicator(
                  color: AppColors.nextBtnBgColor,
                  onRefresh: () => controller.getCategoryList(forceRefresh: true),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 20),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxis,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 4 / 5,
                    ),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return CategoryCardWidget(
                        category: cat,
                        index: index,
                        onTap: () => controller.selectCategory(cat),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
