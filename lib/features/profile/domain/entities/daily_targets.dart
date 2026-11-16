import 'package:kalori/core/utilities/nutrition_goals.dart';

/// Daily calorie and macro targets plus how they were derived.
class DailyTargets {
  /// Basal metabolic rate (kcal burned at rest).
  final int bmr;

  /// Total daily energy expenditure (BMR × activity).
  final int tdee;

  /// Deficit (negative) or surplus (positive) applied for the goal pace.
  final int adjustment;

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  /// True when the calorie floor (1,500 male / 1,200 female) raised the target.
  final bool floorApplied;

  /// Weeks to reach the target weight; null for maintain.
  final int? weeksToGoal;

  const DailyTargets({
    required this.bmr,
    required this.tdee,
    required this.adjustment,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.floorApplied = false,
    this.weeksToGoal,
  });

  /// Used before a profile exists.
  static const DailyTargets fallback = DailyTargets(
    bmr: 0,
    tdee: NutritionGoals.calories,
    adjustment: 0,
    calories: NutritionGoals.calories,
    protein: NutritionGoals.protein,
    carbs: NutritionGoals.carbs,
    fat: NutritionGoals.fat,
  );
}
