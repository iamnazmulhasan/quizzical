import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/helper/api_checker.dart';
import '../../../../data/datasource/model/api_response.dart';
import '../../domain/models/category_model.dart';
import '../../domain/services/category_service_interface.dart';

class CategoryController extends GetxController {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  var categorySelectedIndex = 0.obs;
  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList =>_categoryList;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> getFeaturedDealList({bool forceRefresh = false}) async {
    await getCategoryList(forceRefresh: forceRefresh);
  }

  Future<void> getCategoryList({bool forceRefresh = false}) async {
    // Session caching: do not refetch if already loaded unless forceRefresh is true
    if (!forceRefresh && _categoryList != null && _categoryList!.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    ApiResponse apiResponse = await categoryServiceInterface?.getCategoryList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200 &&
        apiResponse.response!.data.toString() != '{}') {
      _categoryList = [];
      apiResponse.response!.data['trivia_categories']
          .forEach((cData) => _categoryList?.add(CategoryModel.fromJson(cData)));
      categorySelectedIndex.value = 0;
      errorMessage.value = '';
    } else {
      errorMessage.value = apiResponse.error?.toString() ?? 'Failed to load categories';
      ApiChecker.checkApi(apiResponse);
    }
    isLoading.value = false;
  }

  void selectCategory(CategoryModel category) {
    Get.toNamed(AppPages.quizConfigPage, arguments: {
      'categoryId': category.id,
      'categoryName': category.name,
    });
  }
}