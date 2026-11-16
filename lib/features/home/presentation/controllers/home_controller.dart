import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/services/water_service.dart';
import 'package:kalori/core/utilities/food_icon_helper.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/home/presentation/models/generic_meal_widget_model.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/usecases/watch_meals.dart';
import 'package:kalori/features/log/presentation/controllers/log_controller.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';

/// Home dashboard state, all derived from logged meals, the profile's targets and water.
class HomeController extends GetxController {
  final WatchMeals _watchMeals = Get.find<WatchMeals>();
  final UserProfileService _profiles = Get.find<UserProfileService>();
  final WaterService _water = Get.find<WaterService>();
  StreamSubscription<List<MealLogEntry>>? _mealsSubscription;

  /// Bottom nav tab (0: Home, 1: Log, 2: History, 3: Profile).
  final RxInt currentTab = 0.obs;

  /// Analysed meal entries, newest first.
  final RxList<MealLogEntry> _entries = <MealLogEntry>[].obs;

  final TextEditingController chatController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _mealsSubscription = _watchMeals.execute().listen((entries) {
      _entries.assignAll(entries.where((e) => e.foodItem != null));
    });
  }

  @override
  void onClose() {
    _mealsSubscription?.cancel();
    chatController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Today
  // ---------------------------------------------------------------------------

  DateTime get today => DateTime.now().dateOnly;

  DailyTargets get targets => _profiles.targets.value;

  DaySummary get todaySummary {
    final date = today;
    final entries = _entries.where((e) => e.createdAt.dateOnly == date).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return DaySummary(date: date, entries: entries, calorieGoal: targets.calories);
  }

  /// Positive while under the goal, negative once over it.
  int get remainingCalories => targets.calories - todaySummary.calories;

  /// Status for today's ring badge (DESIGN.md §2.5 thresholds, applied to today so far).
  DayStatus get todayStatus {
    final p = todaySummary.progress;
    if (p > 1.0) {
      return DayStatus.over;
    }
    if (p >= 0.9) {
      return DayStatus.close;
    }
    return DayStatus.onTrack;
  }

  int get waterGlasses => _water.today;

  int get waterGoal => _water.goal.value;

  int get streak => Get.isRegistered<HistoryController>() ? Get.find<HistoryController>().currentStreak : 0;

  String get initials => _profiles.profile.value?.initials ?? '';

  /// The three most recent analysed meals, any day.
  List<GenericMealWidgetModel> get recentLogs {
    final now = today;
    return _entries.take(3).map((e) {
      final food = e.foodItem!;
      final icon = FoodIconHelper.getIconForFood(food.title);
      final day = e.createdAt.dateOnly == now ? 'Today' : HistoryFormat.shortDate(e.createdAt);
      return GenericMealWidgetModel(
        title: food.title,
        subtitle: '$day · ${HistoryFormat.time(e.createdAt)}',
        trailingText: '${HistoryFormat.number(food.nutritionalInfo.calories)} kcal',
        icon: icon.icon,
        iconBgColor: icon.iconBgColor,
        iconColor: icon.iconColor,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void changeTab(int index) {
    currentTab.value = index;
  }

  /// Sends the Home chat text to the Log tab, which analyses and saves it.
  void submitChatLog() {
    final text = chatController.text.trim();
    if (text.isEmpty) {
      return;
    }
    chatController.clear();
    Get.find<LogController>().handleExternalLogInput(text);
    changeTab(1);
  }
}
