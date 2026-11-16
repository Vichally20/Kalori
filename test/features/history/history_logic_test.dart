import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/domain/usecases/group_meals_by_day.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/entities/nutritional_info.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';

MealLogEntry _entry(DateTime at, int calories, {bool analysed = true}) {
  return MealLogEntry(
    id: '${at.toIso8601String()}-$calories',
    rawInput: 'food',
    syncStatus: analysed ? SyncStatus.synced : SyncStatus.pending,
    createdAt: at,
    foodItem: analysed
        ? FoodItem(
            title: 'Food',
            subtitle: '1 serving',
            nutritionalInfo: NutritionalInfo(calories: calories, carbs: 10, protein: 5, fat: 2),
          )
        : null,
  );
}

void main() {
  final today = DateTime(2026, 10, 24, 15);
  final yesterday = DateTime(2026, 10, 23);

  DaySummary summary(DateTime date, List<int> calories) => DaySummary(
        date: date.dateOnly,
        entries: [for (final c in calories) _entry(date, c)],
        calorieGoal: 2000,
      );

  group('DaySummary.statusFor', () {
    test('under 90% is on track', () {
      expect(summary(yesterday, [1000, 790]).statusFor(today), DayStatus.onTrack);
    });

    test('90% to 100% is close', () {
      expect(summary(yesterday, [1800]).statusFor(today), DayStatus.close);
      expect(summary(yesterday, [2000]).statusFor(today), DayStatus.close);
    });

    test('over 100% is over', () {
      expect(summary(yesterday, [2001]).statusFor(today), DayStatus.over);
    });

    test('past day with no logs is missed', () {
      expect(summary(yesterday, []).statusFor(today), DayStatus.missed);
    });

    test('today is in progress and tomorrow is future', () {
      expect(summary(today, [2500]).statusFor(today), DayStatus.inProgress);
      expect(summary(DateTime(2026, 10, 25), []).statusFor(today), DayStatus.future);
    });

    test('sums macros', () {
      final s = summary(yesterday, [300, 200]);
      expect(s.calories, 500);
      expect(s.carbs, 20);
      expect(s.protein, 10);
      expect(s.fat, 4);
    });
  });

  test('GroupMealsByDay groups by day, sorts oldest first and skips unanalysed', () {
    final grouped = const GroupMealsByDay().execute([
      _entry(DateTime(2026, 10, 23, 19), 500),
      _entry(DateTime(2026, 10, 23, 8), 300),
      _entry(DateTime(2026, 10, 23, 12), 0, analysed: false),
      _entry(DateTime(2026, 10, 24, 9), 250),
    ]);

    expect(grouped.keys, unorderedEquals([DateTime(2026, 10, 23), DateTime(2026, 10, 24)]));
    expect(grouped[DateTime(2026, 10, 23)]!.map((e) => e.createdAt.hour), [8, 19]);
  });

  group('HistoryFormat', () {
    test('number adds thousands separators', () {
      expect(HistoryFormat.number(0), '0');
      expect(HistoryFormat.number(750), '750');
      expect(HistoryFormat.number(1250), '1,250');
      expect(HistoryFormat.number(1234567), '1,234,567');
      expect(HistoryFormat.number(-2240), '-2,240');
    });

    test('dates and times', () {
      expect(HistoryFormat.monthYear(DateTime(2026, 10)), 'October 2026');
      expect(HistoryFormat.weekday(DateTime(2026, 10, 23)), 'Friday');
      expect(HistoryFormat.weekRange(DateTime(2026, 10, 18), DateTime(2026, 10, 24)), 'Oct 18 – 24');
      expect(HistoryFormat.weekRange(DateTime(2026, 9, 27), DateTime(2026, 10, 3)), 'Sep 27 – Oct 3');
      expect(HistoryFormat.time(DateTime(2026, 10, 23, 8, 5)), '8:05 AM');
      expect(HistoryFormat.time(DateTime(2026, 10, 23, 0, 30)), '12:30 AM');
      expect(HistoryFormat.time(DateTime(2026, 10, 23, 19, 45)), '7:45 PM');
    });
  });
}
