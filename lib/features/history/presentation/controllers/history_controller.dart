import 'dart:async';

import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/utilities/app_logger.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/domain/entities/period_stats.dart';
import 'package:kalori/features/history/domain/usecases/group_meals_by_day.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/usecases/watch_meals.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';

/// Which range the History tab is showing.
enum HistoryRange { month, week }

class HistoryController extends GetxController {
  final WatchMeals _watchMeals = Get.find<WatchMeals>();
  final GroupMealsByDay _groupMealsByDay = const GroupMealsByDay();
  StreamSubscription<List<MealLogEntry>>? _mealsSubscription;

  /// Month is the default view.
  final Rx<HistoryRange> range = HistoryRange.month.obs;

  /// First day of the month shown in the Month view.
  late final Rx<DateTime> focusedMonth;

  /// Sunday that starts the week shown in the Week view.
  late final Rx<DateTime> focusedWeekStart;

  /// Day shown on the Day detail screen.
  late final Rx<DateTime> selectedDay;

  final RxBool isLoading = true.obs;
  final RxMap<DateTime, List<MealLogEntry>> _mealsByDay = <DateTime, List<MealLogEntry>>{}.obs;

  /// Daily targets from the user's profile (fallback 2,000 kcal before onboarding).
  DailyTargets get targets => Get.isRegistered<UserProfileService>()
      ? Get.find<UserProfileService>().targets.value
      : DailyTargets.fallback;

  int get calorieGoal => targets.calories;

  DateTime get today => DateTime.now().dateOnly;

  @override
  void onInit() {
    super.onInit();
    final now = today;
    focusedMonth = DateTime(now.year, now.month).obs;
    focusedWeekStart = _weekStartOf(now).obs;
    selectedDay = now.obs;

    _mealsSubscription = _watchMeals.execute().listen(
      (entries) {
        _mealsByDay.assignAll(_groupMealsByDay.execute(entries));
        isLoading.value = false;
      },
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.e('History failed to load meals', error: error, stackTrace: stackTrace);
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _mealsSubscription?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Days
  // ---------------------------------------------------------------------------

  DaySummary summaryFor(DateTime day) {
    final date = day.dateOnly;
    return DaySummary(
      date: date,
      entries: _mealsByDay[date] ?? const <MealLogEntry>[],
      calorieGoal: calorieGoal,
    );
  }

  DayStatus statusFor(DateTime day) => summaryFor(day).statusFor(today);

  void setRange(HistoryRange value) => range.value = value;

  /// Opens Day detail for [day]. Future days are ignored.
  void openDay(DateTime day) {
    final date = day.dateOnly;
    if (date.isAfter(today)) {
      return;
    }
    selectedDay.value = date;
    Get.toNamed<void>(AppRoutes.historyDay);
  }

  bool get canGoToNextDay => selectedDay.value.isBefore(today);

  void previousDay() => selectedDay.value = _addDays(selectedDay.value, -1);

  void nextDay() {
    if (canGoToNextDay) {
      selectedDay.value = _addDays(selectedDay.value, 1);
    }
  }

  // ---------------------------------------------------------------------------
  // Month
  // ---------------------------------------------------------------------------

  List<DateTime> get focusedMonthDays {
    final first = focusedMonth.value;
    final dayCount = DateTime(first.year, first.month + 1, 0).day;
    return List<DateTime>.generate(dayCount, (i) => DateTime(first.year, first.month, i + 1));
  }

  bool get canGoToNextMonth {
    final now = today;
    return focusedMonth.value.isBefore(DateTime(now.year, now.month));
  }

  void previousMonth() {
    final m = focusedMonth.value;
    focusedMonth.value = DateTime(m.year, m.month - 1);
  }

  void nextMonth() {
    if (canGoToNextMonth) {
      final m = focusedMonth.value;
      focusedMonth.value = DateTime(m.year, m.month + 1);
    }
  }

  // ---------------------------------------------------------------------------
  // Week
  // ---------------------------------------------------------------------------

  List<DateTime> get focusedWeekDays {
    final start = focusedWeekStart.value;
    return List<DateTime>.generate(7, (i) => _addDays(start, i));
  }

  List<DateTime> get previousWeekDays {
    final start = _addDays(focusedWeekStart.value, -7);
    return List<DateTime>.generate(7, (i) => _addDays(start, i));
  }

  bool get isCurrentWeek => focusedWeekStart.value == _weekStartOf(today);

  bool get canGoToNextWeek => focusedWeekStart.value.isBefore(_weekStartOf(today));

  void previousWeek() => focusedWeekStart.value = _addDays(focusedWeekStart.value, -7);

  void nextWeek() {
    if (canGoToNextWeek) {
      focusedWeekStart.value = _addDays(focusedWeekStart.value, 7);
    }
  }

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  PeriodStats statsFor(List<DateTime> days) {
    final now = today;
    var elapsed = 0;
    var logged = 0;
    var completed = 0;
    var onTrack = 0;
    var close = 0;
    var over = 0;
    var missed = 0;
    var calories = 0;
    var carbs = 0;
    var protein = 0;
    var fat = 0;

    for (final day in days) {
      final summary = summaryFor(day);
      final status = summary.statusFor(now);
      if (status == DayStatus.future) {
        continue;
      }
      elapsed++;
      if (summary.hasLogs) {
        logged++;
      }
      switch (status) {
        case DayStatus.onTrack:
          onTrack++;
        case DayStatus.close:
          close++;
        case DayStatus.over:
          over++;
        case DayStatus.missed:
          missed++;
        case DayStatus.inProgress:
        case DayStatus.future:
          break;
      }
      if (status != DayStatus.inProgress && summary.hasLogs) {
        completed++;
        calories += summary.calories;
        carbs += summary.carbs;
        protein += summary.protein;
        fat += summary.fat;
      }
    }

    int avg(int total) => completed == 0 ? 0 : (total / completed).round();

    return PeriodStats(
      elapsedDays: elapsed,
      loggedDays: logged,
      completedDays: completed,
      onTrack: onTrack,
      close: close,
      over: over,
      missed: missed,
      averageCalories: avg(calories),
      averageCarbs: avg(carbs),
      averageProtein: avg(protein),
      averageFat: avg(fat),
    );
  }

  /// Every day with at least one analysed meal, oldest first.
  List<DateTime> get loggedDays => _mealsByDay.keys.toList()..sort();

  /// Stats across all logged days (used by Profile).
  PeriodStats get allTimeStats => statsFor(loggedDays);

  /// Consecutive days with at least one log, ending today (or yesterday if today is empty).
  int get currentStreak {
    var day = today;
    if (!summaryFor(day).hasLogs) {
      day = _addDays(day, -1);
    }
    var streak = 0;
    while (summaryFor(day).hasLogs) {
      streak++;
      day = _addDays(day, -1);
    }
    return streak;
  }

  /// Longest run of logged days inside [days].
  int bestStreakIn(List<DateTime> days) {
    var best = 0;
    var run = 0;
    for (final day in days) {
      if (summaryFor(day).hasLogs) {
        run++;
        if (run > best) {
          best = run;
        }
      } else {
        run = 0;
      }
    }
    return best;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Weeks start on Sunday (DateTime.weekday: Monday = 1 … Sunday = 7).
  static DateTime _weekStartOf(DateTime day) => _addDays(day.dateOnly, -(day.weekday % 7));

  /// Calendar-safe day arithmetic (avoids DST issues of Duration-based math).
  static DateTime _addDays(DateTime day, int days) => DateTime(day.year, day.month, day.day + days);
}
