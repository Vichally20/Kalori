/// Biological sex, used only as an input to the BMR formula.
enum Sex { male, female }

/// Activity multipliers for TDEE (DESIGN.md §14).
enum ActivityLevel {
  sedentary(1.2, 'Mostly sitting', 'Desk or office work, little walking.'),
  light(1.375, 'Lightly active', 'On your feet some of the day, or light exercise 1–3 days a week.'),
  moderate(1.55, 'Moderately active', 'You walk a lot or work out 3–5 days a week.'),
  veryActive(1.725, 'Very active', 'Hard exercise most days, or a physical job like farming or loading.'),
  athlete(1.9, 'Athlete', 'Training twice a day, or heavy labour plus exercise.');

  final double multiplier;
  final String label;
  final String description;

  const ActivityLevel(this.multiplier, this.label, this.description);
}

enum GoalType {
  lose('Lose weight'),
  maintain('Maintain'),
  gain('Gain weight');

  final String label;

  const GoalType(this.label);
}

/// Weekly rate of change for lose / gain goals.
enum GoalPace {
  gentle(0.25, 'Gentle'),
  steady(0.5, 'Steady'),
  faster(0.75, 'Faster');

  final double kgPerWeek;
  final String label;

  const GoalPace(this.kgPerWeek, this.label);
}

class WeightEntry {
  final DateTime date;
  final double kg;

  const WeightEntry({required this.date, required this.kg});
}

/// Everything onboarding collects, plus the weight log and app preferences.
class UserProfile {
  final String name;
  final Sex sex;
  final int age;
  final double heightCm;

  /// Weight when the goal was set; the starting point of the progress bar.
  final double startWeightKg;

  /// Latest logged weight.
  final double weightKg;

  final double targetWeightKg;
  final ActivityLevel activity;
  final GoalType goal;
  final GoalPace pace;
  final DateTime createdAt;
  final bool mealRemindersEnabled;

  /// Oldest first.
  final List<WeightEntry> weightLog;

  const UserProfile({
    required this.name,
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.startWeightKg,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activity,
    required this.goal,
    required this.pace,
    required this.createdAt,
    this.mealRemindersEnabled = true,
    this.weightLog = const [],
  });

  UserProfile copyWith({
    String? name,
    Sex? sex,
    int? age,
    double? heightCm,
    double? startWeightKg,
    double? weightKg,
    double? targetWeightKg,
    ActivityLevel? activity,
    GoalType? goal,
    GoalPace? pace,
    DateTime? createdAt,
    bool? mealRemindersEnabled,
    List<WeightEntry>? weightLog,
  }) {
    return UserProfile(
      name: name ?? this.name,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      startWeightKg: startWeightKg ?? this.startWeightKg,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activity: activity ?? this.activity,
      goal: goal ?? this.goal,
      pace: pace ?? this.pace,
      createdAt: createdAt ?? this.createdAt,
      mealRemindersEnabled: mealRemindersEnabled ?? this.mealRemindersEnabled,
      weightLog: weightLog ?? this.weightLog,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get firstName {
    final trimmed = name.trim();
    return trimmed.isEmpty ? 'there' : trimmed.split(RegExp(r'\s+')).first;
  }
}
