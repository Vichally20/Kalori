import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/theme_service.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/services/water_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/period_stats.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/presentation/widgets/value_input_dialog.dart';
import 'package:kalori/shared/shared.dart';

class ProfileController extends GetxController {
  final UserProfileService profiles = Get.find<UserProfileService>();

  UserProfile? get profile => profiles.profile.value;

  DailyTargets get targets => profiles.targets.value;

  HistoryController? get _history =>
      Get.isRegistered<HistoryController>() ? Get.find<HistoryController>() : null;

  int get streak => _history?.currentStreak ?? 0;

  PeriodStats? get allTime => _history?.allTimeStats;

  /// Share of completed logged days that were on track, 0–100.
  int get onTrackPercent {
    final stats = allTime;
    if (stats == null || stats.completedDays == 0) {
      return 0;
    }
    return (stats.onTrack / stats.completedDays * 100).round();
  }

  /// Opens one onboarding step as an edit screen.
  void editStep(int step) {
    Get.toNamed<void>(AppRoutes.onboarding, arguments: OnboardingArgs(editStep: step));
  }

  /// Opens the weight log, where today's weight is logged and past entries are listed.
  void openWeightLog() => Get.toNamed<void>(AppRoutes.weightLog);

  int get waterToday => Get.find<WaterService>().today;

  int get waterGoal => Get.find<WaterService>().goal.value;

  void openWater() => Get.toNamed<void>(AppRoutes.water);

  static const Map<ThemeMode, String> _appearanceLabels = {
    ThemeMode.system: 'System',
    ThemeMode.light: 'Light',
    ThemeMode.dark: 'Dark',
  };

  String get appearanceLabel => _appearanceLabels[Get.find<ThemeService>().mode.value]!;

  /// Lets the user pick System / Light / Dark in a bottom sheet.
  Future<void> chooseAppearance() async {
    final theme = Get.find<ThemeService>();
    final picked = await Get.bottomSheet<ThemeMode>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 12.0, KaloriSpacing.containerMargin, 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(color: KaloriColors.outlineVariant, borderRadius: KaloriRadius.borderFull),
                ),
              ),
              const SizedBox(height: KaloriSpacing.md),
              Text(
                'Appearance',
                style: KaloriTypography.headlineMd.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: KaloriSpacing.xs),
              RadioGroup<ThemeMode>(
                groupValue: theme.mode.value,
                onChanged: (m) => Get.back<ThemeMode>(result: m),
                child: Column(
                  children: [
                    for (final entry in _appearanceLabels.entries)
                      RadioListTile<ThemeMode>(
                        value: entry.key,
                        contentPadding: EdgeInsets.zero,
                        activeColor: KaloriColors.primary,
                        title: Text(entry.value, style: KaloriTypography.bodyLg.copyWith(color: KaloriColors.onSurface)),
                        subtitle: entry.key == ThemeMode.system
                            ? Text('Match your phone setting', style: KaloriTypography.bodySm)
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: KaloriColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
    );
    if (picked != null) {
      await theme.setMode(picked);
    }
  }

  void startOnboarding() => Get.offAllNamed<void>(AppRoutes.onboarding);

  Future<void> editName() async {
    final current = profile;
    if (current == null) {
      return;
    }
    final result = await Get.dialog<String>(
      ValueInputDialog(
        title: 'Your name',
        initialText: current.name,
        keyboardType: TextInputType.name,
        validator: (v) => v.trim().isEmpty ? 'Enter a name' : null,
      ),
    );
    if (result != null) {
      await profiles.save(current.copyWith(name: result.trim()));
    }
  }

  Future<void> setMealReminders(bool enabled) async {
    final current = profile;
    if (current != null) {
      await profiles.save(current.copyWith(mealRemindersEnabled: enabled));
    }
  }

  void comingSoon(String feature) {
    KaloriToast.showInfo(title: '$feature is coming soon', message: "We're still building this part of Kalori.");
  }

  Future<void> resetAllData() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: KaloriColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderLg),
        title: const Text('Reset all data?'),
        content: const Text(
          'This permanently deletes your profile, goals, weight history and every logged meal on this phone. It cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back<bool>(result: false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KaloriColors.error,
              foregroundColor: KaloriColors.onError,
              minimumSize: const Size(0, 44.0),
              shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderDefault),
            ),
            onPressed: () => Get.back<bool>(result: true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    if (Get.isRegistered<LogRepository>()) {
      await Get.find<LogRepository>().clearAll();
    }
    await Get.find<WaterService>().clear();
    await profiles.clear();
    startOnboarding();
  }
}
