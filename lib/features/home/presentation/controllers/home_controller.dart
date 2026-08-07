import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/features/home/domain/usecases/get_recent_logs.dart';
import '../models/generic_meal_widget_model.dart';
import '../../../log/presentation/controllers/log_controller.dart';
import '../../../log/domain/entities/food_item.dart';
import '../../../log/domain/entities/nutritional_info.dart';
import '../../../../core/utilities/food_icon_helper.dart';

class HomeController extends GetxController {
  final GetRecentLogs getRecentLogsUseCase = Get.find<GetRecentLogs>();

  final RxList<GenericMealWidgetModel> recentLogs =
      <GenericMealWidgetModel>[].obs;
  // Bottom Nav Bar state (0: Home, 1: Log, 2: History, 3: Profile)
  final RxInt currentTab = 0.obs;

  // Calorie & Stats State
  final RxInt remainingCalories = 1250.obs;
  final RxInt eatenCalories = 750.obs;
  final RxInt burnedCalories = 320.obs;
  final RxInt netCalories = 430.obs;
  final RxDouble progressPercent = 0.65.obs; // ~65% eaten/goal

  // Macros State
  final RxInt carbsCurrent = 142.obs;
  final RxInt carbsGoal = 200.obs;

  final RxInt proteinCurrent = 95.obs;
  final RxInt proteinGoal = 180.obs;

  final RxInt fatCurrent = 42.obs;
  final RxInt fatGoal = 70.obs;

  // Floating Chat Input Controller
  final TextEditingController chatController = TextEditingController();
  final RxString chatText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentLogs();
  }

  GenericMealWidgetModel _mapFoodItemToUiModel(FoodItem item) {
    final iconResult = FoodIconHelper.getIconForFood(item.title);
    return GenericMealWidgetModel(
      title: item.title,
      subtitle: item.subtitle,
      trailingText: '${item.nutritionalInfo.calories} kcal',
      icon: iconResult.icon,
      iconBgColor: iconResult.iconBgColor,
      iconColor: iconResult.iconColor,
    );
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  Future<void> _loadRecentLogs() async {
    final foodItems = await getRecentLogsUseCase.execute();
    recentLogs.assignAll(foodItems.map(_mapFoodItemToUiModel).toList());
  }

  void submitChatLog() {
    if (chatController.text.trim().isNotEmpty) {
      final text = chatController.text.trim();
      // Add custom entry to recentLogs list
      final newItem = FoodItem(
        title: text,
        subtitle: 'Just now',
        nutritionalInfo: const NutritionalInfo(
          calories: 200,
          carbs: 10,
          protein: 5,
          fat: 5,
        ),
      );
      recentLogs.insert(0, _mapFoodItemToUiModel(newItem));

      chatController.clear();
      chatText.value = '';

      // Pass input to LogController and instantly redirect to the Log screen
      final LogController logController = Get.find<LogController>();
      logController.handleExternalLogInput(text);

      // Instantly switch to Log tab (index 1)
      changeTab(1);
    }
  }

  @override
  void onClose() {
    chatController.dispose();
    super.onClose();
  }
}
