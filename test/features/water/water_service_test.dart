import 'package:flutter_test/flutter_test.dart';
import 'package:kalori/core/services/water_service.dart';
import 'package:kalori/features/water/data/water_local_data_source.dart';

class _MemorySource extends WaterLocalDataSource {
  Map<String, dynamic>? stored;

  @override
  Future<Map<String, dynamic>?> read() async => stored;

  @override
  Future<void> write(Map<String, dynamic> json) async => stored = json;

  @override
  Future<void> delete() async => stored = null;
}

void main() {
  late _MemorySource source;
  late WaterService water;

  setUp(() async {
    source = _MemorySource();
    water = await WaterService(source: source).init();
  });

  test('starts at zero with the default goal', () {
    expect(water.today, 0);
    expect(water.goal.value, WaterService.defaultGoal);
  });

  test('add and remove glasses for today and persist them', () async {
    await water.addGlass();
    await water.addGlass();
    await water.removeGlass();
    expect(water.today, 1);
    expect((source.stored!['days'] as Map)[WaterService.keyFor(DateTime.now())], 1);
  });

  test('never goes below zero and zero days are dropped', () async {
    await water.removeGlass();
    expect(water.today, 0);
    expect(water.days, isEmpty);
  });

  test('days are independent and reload from storage', () async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await water.setGlasses(yesterday, 6);
    await water.setGoal(10);
    final reloaded = await WaterService(source: source).init();
    expect(reloaded.glassesOn(yesterday), 6);
    expect(reloaded.today, 0);
    expect(reloaded.goal.value, 10);
  });

  test('clear wipes data and resets the goal', () async {
    await water.addGlass();
    await water.setGoal(12);
    await water.clear();
    expect(water.today, 0);
    expect(water.goal.value, WaterService.defaultGoal);
    expect(source.stored, isNull);
  });
}
