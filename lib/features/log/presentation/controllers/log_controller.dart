import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/nutritional_info.dart';

class LogController extends GetxController {
  // Whether the meal breakdown card is currently expanded (true) or contracted (false)
  final RxBool isMealBreakdownExpanded = true.obs;
  // Kept for backwards compatibility if needed
  final RxBool showMealBreakdown = true.obs;

  // Text controller for "What else did you eat?" floating bar
  final TextEditingController inputController = TextEditingController();

  // Chat conversation history
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

  // Food items inside the current meal breakdown card
  final RxList<FoodItem> foodItems = <FoodItem>[
    FoodItem(
      title: 'Large Eggs (2)',
      subtitle: 'Boiled or Poached',
      nutritionalInfo: const NutritionalInfo(calories: 140, carbs: 1, protein: 12, fat: 10),
    ),
    FoodItem(
      title: 'Whole Grain Toast',
      subtitle: '1 regular slice',
      nutritionalInfo: const NutritionalInfo(calories: 100, carbs: 13, protein: 4, fat: 1),
    ),
  ].obs;

  // Meal breakdown macros
  final RxInt carbsCurrent = 14.obs;
  final RxInt proteinCurrent = 16.obs;
  final RxInt fatCurrent = 11.obs;

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
  void addSuggestion(String suggestion) {
    if (suggestion == 'ADD BLACK COFFEE') {
      chatMessages.add(ChatMessage(text: 'Add black coffee', isUser: true));
      chatMessages.add(
        ChatMessage(
          text: 'Added Black Coffee (1 cup) • 5 kcal.',
          isUser: false,
        ),
      );
      foodItems.add(
        FoodItem(
          title: 'Black Coffee',
          subtitle: '1 regular cup (without sugar)',
          nutritionalInfo: const NutritionalInfo(calories: 5, carbs: 0, protein: 0, fat: 0),
        ),
      );
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
      KaloriToast.showSuccess(
        title: 'Black Coffee Added ☕',
        message: 'Logged 1 regular cup (without sugar) • 5 kcal.',
        position: SnackPosition.BOTTOM,
      );
    } else if (suggestion == 'ADD OAT MILK LATTE') {
      chatMessages.add(ChatMessage(text: 'Add oat milk latte', isUser: true));
      chatMessages.add(
        ChatMessage(
          text: 'Added Oat Milk Latte (1 medium) • 120 kcal.',
          isUser: false,
        ),
      );
      foodItems.add(
        FoodItem(
          title: 'Oat Milk Latte',
          subtitle: '1 medium cup',
          nutritionalInfo: const NutritionalInfo(calories: 120, carbs: 14, protein: 3, fat: 5),
        ),
      );
      carbsCurrent.value += 14;
      proteinCurrent.value += 3;
      fatCurrent.value += 5;
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
      KaloriToast.showSuccess(
        title: 'Oat Milk Latte Added ☕',
        message: 'Logged 1 medium cup • 120 kcal.',
        position: SnackPosition.BOTTOM,
      );
    } else if (suggestion == 'ADD ESPRESSO') {
      chatMessages.add(ChatMessage(text: 'Add double espresso', isUser: true));
      chatMessages.add(
        ChatMessage(
          text: 'Added Double Espresso • 3 kcal.',
          isUser: false,
        ),
      );
      foodItems.add(
        FoodItem(
          title: 'Double Espresso',
          subtitle: '2 shots (60ml)',
          nutritionalInfo: const NutritionalInfo(calories: 3, carbs: 1, protein: 0, fat: 0),
        ),
      );
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
      KaloriToast.showSuccess(
        title: 'Double Espresso Added ⚡',
        message: 'Logged 2 shots (60ml) • 3 kcal.',
        position: SnackPosition.BOTTOM,
      );
    } else if (suggestion == 'ADD AVOCADO') {
      chatMessages.add(ChatMessage(text: 'Add half an avocado', isUser: true));
      chatMessages.add(
        ChatMessage(
          text: 'Added Avocado (1/2 medium) • 160 kcal.',
          isUser: false,
        ),
      );
      foodItems.add(
        FoodItem(
          title: 'Avocado',
          subtitle: '1/2 medium sliced',
          nutritionalInfo: const NutritionalInfo(calories: 160, carbs: 4, protein: 2, fat: 15),
        ),
      );
      fatCurrent.value += 15;
      carbsCurrent.value += 4;
      proteinCurrent.value += 2;
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
      KaloriToast.showSuccess(
        title: 'Avocado Added 🥑',
        message: 'Logged 1/2 medium sliced • 160 kcal.',
        position: SnackPosition.BOTTOM,
      );
    } else if (suggestion == 'EDIT MEAL') {
      KaloriToast.showInfo(
        title: 'Edit Meal',
        message: 'You can now tap any item below to edit portions.',
        position: SnackPosition.BOTTOM,
      );
    }
  }

  // Handle external input from home screen chat bar or anywhere else
  void handleExternalLogInput(String text) {
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
      foodItems.add(
        FoodItem(
          title: cleanText,
          subtitle: 'Added just now',
          nutritionalInfo: const NutritionalInfo(calories: 180, carbs: 12, protein: 8, fat: 6),
        ),
      );
      carbsCurrent.value += 12;
      proteinCurrent.value += 8;
      fatCurrent.value += 6;
      showMealBreakdown.value = true;
      isMealBreakdownExpanded.value = true;
    }
  }

  // Handle submitting manual input from the bottom bar
  void submitInput() {
    final String text = inputController.text.trim();
    if (text.isNotEmpty) {
      inputController.clear();
      handleExternalLogInput(text);
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
