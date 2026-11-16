import 'package:get/get.dart';
import 'package:kalori/features/water/data/water_local_data_source.dart';

/// Daily water intake in glasses (250 ml), stored on the device.
class WaterService extends GetxService {
  static const int defaultGoal = 8;
  static const int maxPerDay = 30;

  final WaterLocalDataSource _source;

  WaterService({WaterLocalDataSource? source}) : _source = source ?? WaterLocalDataSource();

  /// Glasses per day, keyed `yyyy-mm-dd`.
  final RxMap<String, int> days = <String, int>{}.obs;
  final RxInt goal = defaultGoal.obs;

  Future<WaterService> init() async {
    final json = await _source.read();
    if (json != null) {
      goal.value = (json['goal'] as num?)?.toInt() ?? defaultGoal;
      final raw = json['days'];
      if (raw is Map<String, dynamic>) {
        days.assignAll({
          for (final e in raw.entries)
            if (e.value is num) e.key: (e.value as num).toInt(),
        });
      }
    }
    return this;
  }

  static String keyFor(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  int glassesOn(DateTime date) => days[keyFor(date)] ?? 0;

  int get today => glassesOn(DateTime.now());

  Future<void> addGlass([DateTime? date]) => setGlasses(date ?? DateTime.now(), glassesOn(date ?? DateTime.now()) + 1);

  Future<void> removeGlass([DateTime? date]) => setGlasses(date ?? DateTime.now(), glassesOn(date ?? DateTime.now()) - 1);

  Future<void> setGlasses(DateTime date, int glasses) async {
    final value = glasses.clamp(0, maxPerDay);
    final key = keyFor(date);
    if (value == 0) {
      days.remove(key);
    } else {
      days[key] = value;
    }
    await _persist();
  }

  Future<void> setGoal(int value) async {
    goal.value = value.clamp(1, maxPerDay);
    await _persist();
  }

  Future<void> clear() async {
    days.clear();
    goal.value = defaultGoal;
    await _source.delete();
  }

  Future<void> _persist() => _source.write(<String, dynamic>{'goal': goal.value, 'days': Map<String, int>.from(days)});
}
