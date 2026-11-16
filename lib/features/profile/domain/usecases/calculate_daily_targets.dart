import 'package:kalori/core/usecases/calculate_tdee.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';

/// Turns a profile into daily targets (DESIGN.md §14).
///
/// - BMR × activity = TDEE (Mifflin-St Jeor via [CalculateTDEE]).
/// - Pace sets the deficit / surplus: 7,700 kcal per kg ÷ 7 days.
/// - Floor: 1,500 kcal (male) / 1,200 kcal (female).
/// - Protein 1.6 g per kg, fat 25% of calories, carbs the rest.
class CalculateDailyTargets {
  static const double kcalPerKg = 7700;
  static const double proteinPerKg = 1.6;
  static const double fatShare = 0.25;

  final CalculateTDEE _tdee;

  const CalculateDailyTargets([this._tdee = const CalculateTDEE()]);

  DailyTargets execute(UserProfile profile) {
    final isMale = profile.sex == Sex.male;
    final bmr = _tdee.execute(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      isMale: isMale,
      activityMultiplier: 1.0,
    );
    final tdee = bmr * profile.activity.multiplier;

    final dailyChange = profile.pace.kgPerWeek * kcalPerKg / 7;
    final adjustment = switch (profile.goal) {
      GoalType.lose => -dailyChange,
      GoalType.gain => dailyChange,
      GoalType.maintain => 0.0,
    };

    final floor = isMale ? 1500 : 1200;
    var calories = (tdee + adjustment).round();
    final floorApplied = calories < floor;
    if (floorApplied) {
      calories = floor;
    }

    final protein = (profile.weightKg * proteinPerKg).round();
    final fat = (calories * fatShare / 9).round();
    final carbs = ((calories - protein * 4 - fat * 9) / 4).round().clamp(0, 100000);

    int? weeks;
    if (profile.goal != GoalType.maintain) {
      final remaining = (profile.weightKg - profile.targetWeightKg).abs();
      weeks = (remaining / profile.pace.kgPerWeek).ceil();
    }

    return DailyTargets(
      bmr: bmr.round(),
      tdee: tdee.round(),
      adjustment: adjustment.round(),
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      floorApplied: floorApplied,
      weeksToGoal: weeks,
    );
  }
}
