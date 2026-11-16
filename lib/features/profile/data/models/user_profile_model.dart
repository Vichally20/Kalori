import 'package:kalori/features/profile/domain/entities/user_profile.dart';

/// JSON mapping for [UserProfile]. Enums are stored by name so reordering them is safe.
class UserProfileModel {
  UserProfileModel._();

  static const int schemaVersion = 1;

  static Map<String, dynamic> toJson(UserProfile p) => <String, dynamic>{
        'v': schemaVersion,
        'name': p.name,
        'sex': p.sex.name,
        'age': p.age,
        'heightCm': p.heightCm,
        'startWeightKg': p.startWeightKg,
        'weightKg': p.weightKg,
        'targetWeightKg': p.targetWeightKg,
        'activity': p.activity.name,
        'goal': p.goal.name,
        'pace': p.pace.name,
        'createdAt': p.createdAt.toIso8601String(),
        'mealRemindersEnabled': p.mealRemindersEnabled,
        'weightLog': [
          for (final e in p.weightLog) <String, dynamic>{'date': e.date.toIso8601String(), 'kg': e.kg},
        ],
      };

  static UserProfile fromJson(Map<String, dynamic> json) {
    T byName<T extends Enum>(List<T> values, Object? name, T fallback) {
      return values.firstWhere((v) => v.name == name, orElse: () => fallback);
    }

    double toDouble(Object? v, double fallback) => v is num ? v.toDouble() : fallback;

    final weightKg = toDouble(json['weightKg'], 70);
    final rawLog = json['weightLog'];
    return UserProfile(
      name: json['name'] as String? ?? '',
      sex: byName(Sex.values, json['sex'], Sex.male),
      age: (json['age'] as num?)?.toInt() ?? 30,
      heightCm: toDouble(json['heightCm'], 170),
      startWeightKg: toDouble(json['startWeightKg'], weightKg),
      weightKg: weightKg,
      targetWeightKg: toDouble(json['targetWeightKg'], weightKg),
      activity: byName(ActivityLevel.values, json['activity'], ActivityLevel.moderate),
      goal: byName(GoalType.values, json['goal'], GoalType.maintain),
      pace: byName(GoalPace.values, json['pace'], GoalPace.steady),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      mealRemindersEnabled: json['mealRemindersEnabled'] as bool? ?? true,
      weightLog: [
        if (rawLog is List)
          for (final e in rawLog.whereType<Map<String, dynamic>>())
            WeightEntry(
              date: DateTime.tryParse(e['date'] as String? ?? '') ?? DateTime.now(),
              kg: toDouble(e['kg'], weightKg),
            ),
      ],
    );
  }
}
