import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/generic_meal_widget_model.dart';
import '../../../log/presentation/controllers/log_controller.dart';
import '../../../log/domain/entities/food_item.dart';
import '../../../log/domain/entities/nutritional_info.dart';

class HomeController extends GetxController {
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

  // Recent Logs State
  late final RxList<GenericMealWidgetModel> recentLogs;

  @override
  void onInit() {
    super.onInit();
    final initialItems = [
      const FoodItem(
        title: 'Boiled Eggs (2)',
        subtitle: 'Breakfast • 8:15 AM',
        nutritionalInfo: NutritionalInfo(calories: 155, carbs: 1, protein: 12, fat: 10),
      ),
      const FoodItem(
        title: 'Oat Milk Latte',
        subtitle: 'Snack • 11:30 AM',
        nutritionalInfo: NutritionalInfo(calories: 120, carbs: 14, protein: 3, fat: 5),
      ),
    ];
    recentLogs = initialItems.map(_mapFoodItemToUiModel).toList().obs;
  }

  GenericMealWidgetModel _mapFoodItemToUiModel(FoodItem item) {
    // Dynamic icon assignment based on title (user requested "yes" to this logic)
    IconData icon = Icons.fastfood_outlined;
    Color iconBgColor = const Color(0xFFEFF4FF);
    Color iconColor = const Color(0xFF0D1C2F);

    final lowercaseTitle = item.title.toLowerCase();
    if (lowercaseTitle.contains('egg')) {
      icon = Icons.egg_alt_outlined;
    } else if (lowercaseTitle.contains('coffee') || lowercaseTitle.contains('latte')) {
      icon = Icons.coffee_outlined;
    } else if (lowercaseTitle.contains('fruit') || lowercaseTitle.contains('apple')) {
      icon = Icons.apple;
    } else if (lowercaseTitle.contains('pizza')) {
      icon = Icons.local_pizza_outlined;
    } else if (lowercaseTitle.contains('avocado')) {
      icon = Icons.eco_outlined;
      iconColor = const Color(0xFF006C49);
    }

    return GenericMealWidgetModel(
      title: item.title,
      subtitle: item.subtitle,
      trailingText: '${item.nutritionalInfo.calories} kcal',
      icon: icon,
      iconBgColor: iconBgColor,
      iconColor: iconColor,
    );
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void submitChatLog() {
    if (chatController.text.trim().isNotEmpty) {
      final text = chatController.text.trim();
      // Add custom entry to recentLogs list
      final newItem = FoodItem(
        title: text,
        subtitle: 'Just now',
        nutritionalInfo: const NutritionalInfo(calories: 200, carbs: 10, protein: 5, fat: 5),
      );
      recentLogs.insert(0, _mapFoodItemToUiModel(newItem));
      
      chatController.clear();
      chatText.value = '';

      // Pass input to LogController and instantly redirect to the Log screen
      final LogController logController = Get.isRegistered<LogController>()
          ? Get.find<LogController>()
          : Get.put(LogController());
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
