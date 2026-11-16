import 'package:get/get.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:kalori/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/domain/repositories/profile_repository.dart';
import 'package:kalori/features/profile/domain/usecases/calculate_daily_targets.dart';

/// App-wide source of the user's profile and the daily targets derived from it.
///
/// Registered permanently in `main()` so Home, History and Profile all read the same targets.
class UserProfileService extends GetxService {
  final ProfileRepository _repository;
  final CalculateDailyTargets _calculate;

  UserProfileService({ProfileRepository? repository, CalculateDailyTargets? calculate})
      : _repository = repository ?? ProfileRepositoryImpl(localDataSource: ProfileLocalDataSource()),
        _calculate = calculate ?? const CalculateDailyTargets();

  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  final Rx<DailyTargets> targets = DailyTargets.fallback.obs;

  bool get hasProfile => profile.value != null;

  Future<UserProfileService> init() async {
    _apply(await _repository.load());
    return this;
  }

  /// Saves [value] and recalculates targets.
  Future<void> save(UserProfile value) async {
    await _repository.save(value);
    _apply(value);
  }

  DailyTargets preview(UserProfile value) => _calculate.execute(value);

  /// Records today's weight (replacing an earlier entry from today) and recalculates targets.
  Future<void> logWeight(double kg) async {
    final current = profile.value;
    if (current == null) {
      return;
    }
    final today = DateTime.now().dateOnly;
    final log = [
      for (final e in current.weightLog)
        if (e.date.dateOnly != today) e,
      WeightEntry(date: today, kg: kg),
    ]..sort((a, b) => a.date.compareTo(b.date));
    await save(current.copyWith(weightKg: kg, weightLog: log));
  }

  Future<void> clear() async {
    await _repository.clear();
    _apply(null);
  }

  void _apply(UserProfile? value) {
    profile.value = value;
    targets.value = value == null ? DailyTargets.fallback : _calculate.execute(value);
  }
}
