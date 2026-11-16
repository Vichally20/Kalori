import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';

/// How a single day went compared with the calorie goal.
enum DayStatus { onTrack, close, over, missed, inProgress, future }

extension DateOnly on DateTime {
  /// This date at local midnight, used as the key for a calendar day.
  DateTime get dateOnly => DateTime(year, month, day);
}

/// All analysed meals logged on one calendar day plus their totals.
class DaySummary {
  /// Local midnight of the day.
  final DateTime date;

  /// Analysed entries (each has a food item), oldest first.
  final List<MealLogEntry> entries;

  final int calorieGoal;

  const DaySummary({
    required this.date,
    required this.entries,
    required this.calorieGoal,
  });

  bool get hasLogs => entries.isNotEmpty;

  int get calories => _sum((e) => e.foodItem!.nutritionalInfo.calories);
  int get carbs => _sum((e) => e.foodItem!.nutritionalInfo.carbs);
  int get protein => _sum((e) => e.foodItem!.nutritionalInfo.protein);
  int get fat => _sum((e) => e.foodItem!.nutritionalInfo.fat);

  /// Fraction of the calorie goal eaten (can exceed 1.0).
  double get progress => calorieGoal <= 0 ? 0 : calories / calorieGoal;

  /// Status rules from DESIGN.md §2.5: under 90% on track, 90–100% close, over 100% over.
  DayStatus statusFor(DateTime today) {
    final todayDate = today.dateOnly;
    if (date.isAfter(todayDate)) {
      return DayStatus.future;
    }
    if (date == todayDate) {
      return DayStatus.inProgress;
    }
    if (!hasLogs) {
      return DayStatus.missed;
    }
    if (progress > 1.0) {
      return DayStatus.over;
    }
    if (progress >= 0.9) {
      return DayStatus.close;
    }
    return DayStatus.onTrack;
  }

  int _sum(int Function(MealLogEntry) pick) {
    var total = 0;
    for (final entry in entries) {
      total += pick(entry);
    }
    return total;
  }
}
