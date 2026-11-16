import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/features/profile/data/models/user_profile_model.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/domain/usecases/calculate_daily_targets.dart';

UserProfile _profile({
  Sex sex = Sex.male,
  double weight = 80,
  double target = 72,
  GoalType goal = GoalType.lose,
  GoalPace pace = GoalPace.steady,
  ActivityLevel activity = ActivityLevel.moderate,
}) {
  return UserProfile(
    name: 'Chidi Adeyemi',
    sex: sex,
    age: 28,
    heightCm: 175,
    startWeightKg: weight,
    weightKg: weight,
    targetWeightKg: target,
    activity: activity,
    goal: goal,
    pace: pace,
    createdAt: DateTime(2026, 9, 7),
  );
}

void main() {
  const calc = CalculateDailyTargets();

  group('CalculateDailyTargets', () {
    test('matches the worked example in DESIGN.md', () {
      final t = calc.execute(_profile());
      expect(t.bmr, 1759);
      expect(t.tdee, 2726);
      expect(t.adjustment, -550);
      expect(t.calories, 2176);
      expect(t.protein, 128);
      expect(t.fat, 60);
      expect(t.carbs, 281);
      expect(t.weeksToGoal, 16);
      expect(t.floorApplied, isFalse);
    });

    test('maintain has no adjustment and no timeline', () {
      final t = calc.execute(_profile(goal: GoalType.maintain));
      expect(t.adjustment, 0);
      expect(t.calories, 2726);
      expect(t.weeksToGoal, isNull);
    });

    test('gain adds a surplus', () {
      final t = calc.execute(_profile(goal: GoalType.gain, target: 85, pace: GoalPace.gentle));
      expect(t.adjustment, 275);
      expect(t.calories, 3001);
      expect(t.weeksToGoal, 20);
    });

    test('never goes below the safety floor', () {
      final t = calc.execute(
        _profile(
          sex: Sex.female,
          weight: 45,
          target: 40,
          pace: GoalPace.faster,
          activity: ActivityLevel.sedentary,
        ),
      );
      expect(t.calories, 1200);
      expect(t.floorApplied, isTrue);
    });
  });

  test('UserProfileModel round-trips through JSON', () {
    final original = _profile().copyWith(
      mealRemindersEnabled: false,
      weightLog: [WeightEntry(date: DateTime(2026, 9, 7), kg: 80), WeightEntry(date: DateTime(2026, 11, 16), kg: 78.4)],
    );
    final restored = UserProfileModel.fromJson(UserProfileModel.toJson(original));

    expect(restored.name, original.name);
    expect(restored.sex, original.sex);
    expect(restored.age, original.age);
    expect(restored.heightCm, original.heightCm);
    expect(restored.weightKg, original.weightKg);
    expect(restored.targetWeightKg, original.targetWeightKg);
    expect(restored.activity, original.activity);
    expect(restored.goal, original.goal);
    expect(restored.pace, original.pace);
    expect(restored.createdAt, original.createdAt);
    expect(restored.mealRemindersEnabled, isFalse);
    expect(restored.weightLog.map((e) => e.kg), [80, 78.4]);
  });

  test('UserProfile initials and first name', () {
    expect(_profile().initials, 'CA');
    expect(_profile().firstName, 'Chidi');
    expect(_profile().copyWith(name: '  ').firstName, 'there');
  });
}
