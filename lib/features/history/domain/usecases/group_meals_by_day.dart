import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';

/// Groups analysed meal entries by local calendar day, each day sorted oldest first.
///
/// Entries still pending or failed (no food item yet) are left out.
class GroupMealsByDay {
  const GroupMealsByDay();

  Map<DateTime, List<MealLogEntry>> execute(List<MealLogEntry> entries) {
    final byDay = <DateTime, List<MealLogEntry>>{};
    for (final entry in entries) {
      if (entry.foodItem == null) {
        continue;
      }
      byDay.putIfAbsent(entry.createdAt.dateOnly, () => <MealLogEntry>[]).add(entry);
    }
    for (final dayEntries in byDay.values) {
      dayEntries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    return byDay;
  }
}
