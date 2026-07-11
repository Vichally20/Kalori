import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class MealFoodItem {
  final String title;
  final String subtitle;
  final String calories;

  MealFoodItem({
    required this.title,
    required this.subtitle,
    required this.calories,
  });
}

class LogController extends GetxController {
  // Whether the meal breakdown card is currently open/visible
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
  final RxList<MealFoodItem> foodItems = <MealFoodItem>[
    MealFoodItem(
      title: 'Large Eggs (2)',
      subtitle: 'Boiled or Poached',
      calories: '140 kcal',
    ),
    MealFoodItem(
      title: 'Whole Grain Toast',
      subtitle: '1 regular slice',
      calories: '100 kcal',
    ),
  ].obs;

  // Meal breakdown macros
  final RxInt carbsCurrent = 14.obs;
  final RxInt proteinCurrent = 16.obs;
  final RxInt fatCurrent = 11.obs;

  // Close / dismiss the meal breakdown card
  void dismissMealBreakdown() {
    showMealBreakdown.value = false;
  }

  // Restore or open the meal breakdown card
  void restoreMealBreakdown() {
    showMealBreakdown.value = true;
  }

  // Handle quick suggestion chips
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
        MealFoodItem(
          title: 'Black Coffee',
          subtitle: '1 regular cup (without sugar)',
          calories: '5 kcal',
        ),
      );
      showMealBreakdown.value = true;
    } else if (suggestion == 'ADD AVOCADO') {
      chatMessages.add(ChatMessage(text: 'Add half an avocado', isUser: true));
      chatMessages.add(
        ChatMessage(
          text: 'Added Avocado (1/2 medium) • 160 kcal.',
          isUser: false,
        ),
      );
      foodItems.add(
        MealFoodItem(
          title: 'Avocado',
          subtitle: '1/2 medium sliced',
          calories: '160 kcal',
        ),
      );
      fatCurrent.value += 15;
      carbsCurrent.value += 4;
      proteinCurrent.value += 2;
      showMealBreakdown.value = true;
    } else if (suggestion == 'EDIT MEAL') {
      Get.snackbar(
        'Edit Meal',
        'You can now tap any item below to edit portions.',
        snackPosition: SnackPosition.BOTTOM,
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
        MealFoodItem(
          title: cleanText,
          subtitle: 'Added just now',
          calories: '180 kcal',
        ),
      );
      carbsCurrent.value += 12;
      proteinCurrent.value += 8;
      fatCurrent.value += 6;
      showMealBreakdown.value = true;
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
