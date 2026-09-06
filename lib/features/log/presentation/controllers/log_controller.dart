import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/utilities/app_logger.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/usecases/get_frequent_meals.dart';
import 'package:kalori/features/log/domain/usecases/log_meal.dart';
import 'package:kalori/features/log/domain/usecases/watch_meals.dart';
import 'package:kalori/shared/shared.dart';

class LogController extends GetxController {
  final LogMeal logMealUseCase = Get.find<LogMeal>();
  final WatchMeals watchMealsUseCase = Get.find<WatchMeals>();
  final GetFrequentMeals getFrequentMealsUseCase = Get.find<GetFrequentMeals>();

  final RxBool isMealBreakdownExpanded = true.obs;
  final RxBool showMealBreakdown = true.obs;
  final TextEditingController inputController = TextEditingController();  
  final RxList<ChatMessage> chatMessages = <ChatMessage>[
    ChatMessage(
      text: 'I had two eggs and a piece of whole grain toast',
      isUser: true,
    ),
    ChatMessage(
      text:
          "Got it! That's approximately 240 calories. You have 1,460 kcal remaining today. You're on track!",
      isUser: false,
    ),
  ].obs;
  final RxList<MealLogEntry> mealEntries = <MealLogEntry>[].obs;
  final RxList<FoodItem> frequentSuggestions = <FoodItem>[].obs;
  
  // Dynamic Macro Calculations
  int get totalCalories {
    int total = 0;
    for (var entry in mealEntries) {
      if (entry.foodItem != null) {
        total += entry.foodItem!.nutritionalInfo.calories;
      }
    }
    return total;
  }

  int get totalCarbs {
    int total = 0;
    for (var entry in mealEntries) {
      if (entry.foodItem != null) {
        total += entry.foodItem!.nutritionalInfo.carbs;
      }
    }
    return total;
  }

  int get totalProtein {
    int total = 0;
    for (var entry in mealEntries) {
      if (entry.foodItem != null) {
        total += entry.foodItem!.nutritionalInfo.protein;
      }
    }
    return total;
  }

  int get totalFat {
    int total = 0;
    for (var entry in mealEntries) {
      if (entry.foodItem != null) {
        total += entry.foodItem!.nutritionalInfo.fat;
      }
    }
    return total;
  }

  @override
  void onInit() {
    super.onInit();
    AppLogger.d('LogController initialized');
    _loadFrequentMeals();
    watchMealsUseCase.execute().listen((entries) {
      AppLogger.d('Received meal entries update (Count: ${entries.length})');
      mealEntries.assignAll(entries);
    });
  }

  // Contract the meal breakdown card
  void contractMealBreakdown() {
    isMealBreakdownExpanded.value = false;
  }

  // Expand the meal breakdown card
  void expandMealBreakdown() {
    isMealBreakdownExpanded.value = true;
  }

  // Toggle meal breakdown expansion
  void toggleMealBreakdown() {
    isMealBreakdownExpanded.value = !isMealBreakdownExpanded.value;
    AppLogger.d('Toggled meal breakdown. Expanded: ${isMealBreakdownExpanded.value}');
  }

  // Close the meal breakdown card (now contracts it instead of hiding)
  void dismissMealBreakdown() {
    isMealBreakdownExpanded.value = false;
  }

  // Restore the meal breakdown card
  void restoreMealBreakdown() {
    isMealBreakdownExpanded.value = true;
  }

  // Handle suggestion chips
  Future<void> addSuggestion(FoodItem food) async {
    AppLogger.i('User tapped suggestion chip for: ${food.title}');
    chatMessages.add(ChatMessage(text: 'Add ${food.title.toLowerCase()}', isUser: true));
    chatMessages.add(
      ChatMessage(
        text: 'Added ${food.title} (${food.subtitle}) • ${food.nutritionalInfo.calories} kcal.',
        isUser: false,
      ),
    );
    
    await logMealUseCase.execute(food.title);
    
    showMealBreakdown.value = true;
    isMealBreakdownExpanded.value = true;
    KaloriToast.showSuccess(
      title: '${food.title} Added ✅',
      message: 'Logged ${food.subtitle} • ${food.nutritionalInfo.calories} kcal.',
      position: SnackPosition.BOTTOM,
    );
  }

  // Handle external input from home screen chat bar or anywhere else
  Future<void> handleExternalLogInput(String text) async {
    if (text.trim().isNotEmpty) {
      final cleanText = text.trim();
      AppLogger.i('User submitted log input: "$cleanText"');
      
      chatMessages.add(ChatMessage(text: cleanText, isUser: true));

      chatMessages.add(
        ChatMessage(
          text: 'Analyzing "$cleanText"...',
          isUser: false,
        ),
      );
      
      await logMealUseCase.execute(cleanText);
      
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
    }
  }

  // Handle submitting manual input from the bottom bar
  Future<void> submitInput() async {
    final String text = inputController.text.trim();
    if (text.isNotEmpty) {
      inputController.clear();
      await handleExternalLogInput(text);
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
  
  Future<void> _loadFrequentMeals() async {
    final frequent = await getFrequentMealsUseCase.execute(limit: 4);
    frequentSuggestions.assignAll(frequent);
  }
}
