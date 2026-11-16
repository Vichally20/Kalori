import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/period_stats.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/log/domain/repositories/log_repository.dart';
import 'package:kalori/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
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

  void startOnboarding() => Get.offAllNamed<void>(AppRoutes.onboarding);

  Future<void> editName() async {
    final current = profile;
    if (current == null) {
      return;
    }
    final result = await Get.dialog<String>(
      _InputDialog(
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

  Future<void> logWeight() async {
    final current = profile;
    if (current == null) {
      return;
    }
    final result = await Get.dialog<String>(
      _InputDialog(
        title: "Today's weight",
        initialText: _trim(current.weightKg),
        suffix: 'kg',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) {
          final kg = double.tryParse(v.replaceAll(',', '.'));
          if (kg == null || kg < OnboardingController.minWeightKg || kg > OnboardingController.maxWeightKg) {
            return 'Enter a weight between 30 and 250 kg';
          }
          return null;
        },
      ),
    );
    final kg = double.tryParse(result?.replaceAll(',', '.') ?? '');
    if (kg != null) {
      await profiles.logWeight(kg);
      KaloriToast.showSuccess(title: 'Weight logged', message: '${_trim(kg)} kg saved for today.');
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
    await profiles.clear();
    startOnboarding();
  }

  static String _trim(double v) {
    final r = (v * 10).round() / 10;
    return r == r.roundToDouble() ? r.round().toString() : r.toStringAsFixed(1);
  }
}

/// Single-field dialog that returns the entered text on Save.
///
/// Owns its [TextEditingController] so it is disposed only after the dialog's
/// closing animation, never while the field is still on screen.
class _InputDialog extends StatefulWidget {
  final String title;
  final String initialText;
  final String? suffix;
  final TextInputType keyboardType;
  final String? Function(String) validator;

  const _InputDialog({
    required this.title,
    required this.initialText,
    required this.keyboardType,
    required this.validator,
    this.suffix,
  });

  @override
  State<_InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  late final TextEditingController _field = TextEditingController(text: widget.initialText);
  String? _error;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.validator(_field.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Get.back<String>(result: _field.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KaloriColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderLg),
      title: Text(widget.title),
      content: TextField(
        controller: _field,
        autofocus: true,
        keyboardType: widget.keyboardType,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(suffixText: widget.suffix, errorText: _error),
      ),
      actions: [
        TextButton(onPressed: () => Get.back<String>(), child: const Text('Cancel')),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
