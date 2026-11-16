import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/domain/repositories/profile_repository.dart';

class _MemoryRepo implements ProfileRepository {
  UserProfile? stored;

  @override
  Future<UserProfile?> load() async => stored;

  @override
  Future<void> save(UserProfile profile) async => stored = profile;

  @override
  Future<void> clear() async => stored = null;
}

void main() {
  late _MemoryRepo repo;
  late UserProfileService service;

  final sep7 = DateTime(2026, 9, 7);
  final oct1 = DateTime(2026, 10);

  setUp(() async {
    repo = _MemoryRepo()
      ..stored = UserProfile(
        name: 'Chidi',
        sex: Sex.male,
        age: 28,
        heightCm: 175,
        startWeightKg: 80,
        weightKg: 79,
        targetWeightKg: 72,
        activity: ActivityLevel.moderate,
        goal: GoalType.lose,
        pace: GoalPace.steady,
        createdAt: sep7,
        weightLog: [WeightEntry(date: sep7, kg: 80), WeightEntry(date: oct1, kg: 79)],
      );
    service = UserProfileService(repository: repo);
    await service.init();
  });

  List<double> kgs() => [for (final e in service.profile.value!.weightLog) e.kg];

  test('logWeight adds today at the end and becomes the current weight', () async {
    await service.logWeight(78.4);
    expect(kgs(), [80, 79, 78.4]);
    expect(service.profile.value!.weightKg, 78.4);
    expect(repo.stored!.weightKg, 78.4);
  });

  test('logging twice on the same day replaces that day', () async {
    await service.logWeight(78.4);
    await service.logWeight(78.1);
    expect(kgs(), [80, 79, 78.1]);
  });

  test('setWeightFor a past date keeps chronological order', () async {
    await service.setWeightFor(DateTime(2026, 9, 20, 18, 30), 79.6);
    expect(kgs(), [80, 79.6, 79]);
    expect(service.profile.value!.weightKg, 79, reason: 'current weight is still the newest entry');
  });

  test('deleting the newest entry falls back to the previous weight', () async {
    await service.deleteWeightFor(oct1);
    expect(kgs(), [80]);
    expect(service.profile.value!.weightKg, 80);
  });

  test('deleting every entry keeps the last known weight', () async {
    await service.deleteWeightFor(oct1);
    await service.deleteWeightFor(sep7);
    expect(kgs(), isEmpty);
    expect(service.profile.value!.weightKg, 80);
  });

  test('targets recalculate when the weight changes', () async {
    final before = service.targets.value.calories;
    await service.logWeight(70);
    expect(service.targets.value.calories, lessThan(before));
  });
}
