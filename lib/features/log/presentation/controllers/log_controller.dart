import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/features/log/domain/usecases/get_meals.dart';
import 'package:kalori/features/log/domain/usecases/log_meal.dart';
import 'package:kalori/features/log/domain/usecases/get_frequent_meals.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/nutritional_info.dart';

class LogController extends GetxController {
  final LogMeal logMealUseCase = Get.find<LogMeal>();
  final GetMealsUsecase getMealsUseCase = Get.find<GetMealsUsecase>();
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
  final RxList<FoodItem> foodItems = <FoodItem>[].obs;
  final RxList<FoodItem> frequentSuggestions = <FoodItem>[].obs;
  
  // Meal breakdown macros
  final RxInt carbsCurrent = 14.obs;
  final RxInt proteinCurrent = 16.obs;
  final RxInt fatCurrent = 11.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMeals();
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
    chatMessages.add(ChatMessage(text: 'Add ${food.title.toLowerCase()}', isUser: true));
    chatMessages.add(
      ChatMessage(
        text: 'Added ${food.title} (${food.subtitle}) • ${food.nutritionalInfo.calories} kcal.',
        isUser: false,
      ),
    );
    
    await logMealUseCase.execute(food);
    foodItems.add(food);
    
    carbsCurrent.value += food.nutritionalInfo.carbs;
    proteinCurrent.value += food.nutritionalInfo.protein;
    fatCurrent.value += food.nutritionalInfo.fat;
    
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
      chatMessages.add(ChatMessage(text: cleanText, isUser: true));

      // Simulate AI response & meal item addition
      chatMessages.add(
        ChatMessage(
          text: "Logged \"$cleanText\" to your current breakdown!",
          isUser: false,
        ),
      );
      final newItem = FoodItem(
        title: cleanText,
        subtitle: 'Added just now',
        nutritionalInfo: const NutritionalInfo(calories: 180, carbs: 12, protein: 8, fat: 6),
      );
      await logMealUseCase.execute(newItem);
      foodItems.add(newItem);
      
      carbsCurrent.value += 12;
      proteinCurrent.value += 8;
      fatCurrent.value += 6;
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
  
  Future<void> _loadMeals() async {
    final meals = await getMealsUseCase.execute();
    foodItems.assignAll(meals);
    
    // Also load frequent meals for suggestions (up to 4)
    final frequent = await getFrequentMealsUseCase.execute(limit: 4);
    frequentSuggestions.assignAll(frequent);
  }


}
