import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/model.dart';
import '../../../log/view/controllers/log_controller.dart';

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
  final RxList<FoodLogItem> recentLogs = <FoodLogItem>[
    FoodLogItem(
      title: 'Boiled Eggs (2)',
      subtitle: 'Breakfast • 8:15 AM',
      calories: '155 kcal',
      icon: Icons.egg_alt_outlined,
      iconBgColor: const Color(0xFFEFF4FF),
      iconColor: const Color(0xFF0D1C2F),
    ),
    FoodLogItem(
      title: 'Oat Milk Latte',
      subtitle: 'Snack • 11:30 AM',
      calories: '120 kcal',
      icon: Icons.coffee_outlined,
      iconBgColor: const Color(0xFFEFF4FF),
      iconColor: const Color(0xFF0D1C2F),
    ),
  ].obs;

  void changeTab(int index) {
    currentTab.value = index;
  }

  void submitChatLog() {
    if (chatController.text.trim().isNotEmpty) {
      final text = chatController.text.trim();
      // Add custom entry to recentLogs list
      recentLogs.insert(
        0,
        FoodLogItem(
          title: text,
          subtitle: 'Just now',
          calories: '200 kcal',
          icon: Icons.fastfood_outlined,
          iconBgColor: const Color(0xFFEFF4FF),
          iconColor: const Color(0xFF006C49),
        ),
      );
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
