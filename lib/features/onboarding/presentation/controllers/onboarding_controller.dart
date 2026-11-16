import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/shared/shared.dart';

/// Passed as `Get.arguments` to open a single step for editing from Profile.
class OnboardingArgs {
  final int editStep;

  const OnboardingArgs({required this.editStep});
}

/// Onboarding steps. Data steps 1–4 show the progress header.
abstract class OnboardingStep {
  static const int welcome = 0;
  static const int about = 1;
  static const int body = 2;
  static const int activity = 3;
  static const int goal = 4;
  static const int plan = 5;
}

class OnboardingController extends GetxController {
  static const double kgPerLb = 0.45359237;
  static const int minAge = 13;
  static const int maxAge = 100;
  static const double minHeightCm = 120;
  static const double maxHeightCm = 220;
  static const double minWeightKg = 30;
  static const double maxWeightKg = 250;

  final UserProfileService _profiles = Get.find<UserProfileService>();

  /// Non-null when Profile opened a single step to edit.
  int? editStep;
  UserProfile? _existing;

  final RxInt step = OnboardingStep.welcome.obs;
  final RxBool isSaving = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  final RxString name = ''.obs;
  final Rx<Sex> sex = Sex.male.obs;
  final RxInt age = 28.obs;
  final RxDouble heightCm = 170.0.obs;
  final RxDouble weightKg = 70.0.obs;
  final RxBool heightInFeet = false.obs;
  final RxBool weightInLb = false.obs;
  final Rx<ActivityLevel> activity = ActivityLevel.moderate.obs;
  final Rx<GoalType> goal = GoalType.lose.obs;
  final RxDouble targetWeightKg = 65.0.obs;
  final Rx<GoalPace> pace = GoalPace.steady.obs;

  bool get isEditing => editStep != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is OnboardingArgs) {
      editStep = args.editStep;
    }

    _existing = _profiles.profile.value;
    final p = _existing;
    if (p != null) {
      name.value = p.name;
      sex.value = p.sex;
      age.value = p.age;
      heightCm.value = p.heightCm;
      weightKg.value = p.weightKg;
      activity.value = p.activity;
      goal.value = p.goal;
      targetWeightKg.value = p.targetWeightKg;
      pace.value = p.pace;
    }
    nameController.text = name.value;
    nameController.addListener(() => name.value = nameController.text);
    _syncTargetText();
    targetController.addListener(_onTargetTyped);

    step.value = editStep ?? OnboardingStep.welcome;
  }

  @override
  void onClose() {
    nameController.dispose();
    targetController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Draft and preview
  // ---------------------------------------------------------------------------

  UserProfile get draft {
    final existing = _existing;
    final today = DateTime.now().dateOnly;
    final weightChanged = existing == null || (existing.weightKg - weightKg.value).abs() > 0.001;
    final log = <WeightEntry>[
      ...?existing?.weightLog.where((e) => !(weightChanged && e.date.dateOnly == today)),
      if (weightChanged) WeightEntry(date: today, kg: weightKg.value),
    ]..sort((a, b) => a.date.compareTo(b.date));

    final goalEdited = editStep == OnboardingStep.goal;
    return UserProfile(
      name: name.value.trim(),
      sex: sex.value,
      age: age.value,
      heightCm: heightCm.value,
      startWeightKg: (existing == null || goalEdited) ? weightKg.value : existing.startWeightKg,
      weightKg: weightKg.value,
      targetWeightKg: goal.value == GoalType.maintain ? weightKg.value : targetWeightKg.value,
      activity: activity.value,
      goal: goal.value,
      pace: pace.value,
      createdAt: existing?.createdAt ?? DateTime.now(),
      mealRemindersEnabled: existing?.mealRemindersEnabled ?? true,
      weightLog: log,
    );
  }

  DailyTargets get preview => _profiles.preview(draft);

  /// Estimated date the target weight is reached, or null for maintain.
  DateTime? get goalDate {
    final weeks = preview.weeksToGoal;
    if (weeks == null) {
      return null;
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + weeks * 7);
  }

  String? get goalError {
    if (goal.value == GoalType.maintain) {
      return null;
    }
    final target = targetWeightKg.value;
    if (target < minWeightKg || target > maxWeightKg) {
      return 'Enter a weight between ${formatWeight(minWeightKg)} and ${formatWeight(maxWeightKg)}.';
    }
    if (goal.value == GoalType.lose && target >= weightKg.value) {
      return 'Your target should be below your current ${formatWeight(weightKg.value)}.';
    }
    if (goal.value == GoalType.gain && target <= weightKg.value) {
      return 'Your target should be above your current ${formatWeight(weightKg.value)}.';
    }
    return null;
  }

  bool get canContinue {
    switch (step.value) {
      case OnboardingStep.about:
        return name.value.trim().isNotEmpty;
      case OnboardingStep.goal:
        return goalError == null;
      default:
        return true;
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void next() {
    if (!canContinue) {
      return;
    }
    if (step.value == OnboardingStep.plan) {
      finish();
      return;
    }
    goToStep(step.value + 1);
  }

  void back() {
    if (isEditing || step.value == OnboardingStep.welcome) {
      Get.back<void>();
      return;
    }
    step.value = step.value - 1;
  }

  void goToStep(int value) {
    if (value == OnboardingStep.goal) {
      _ensureSensibleTarget();
    }
    step.value = value;
  }

  Future<void> finish() async {
    if (isSaving.value) {
      return;
    }
    isSaving.value = true;
    try {
      await _profiles.save(draft);
      Get.offAllNamed<void>(AppRoutes.home);
    } finally {
      isSaving.value = false;
    }
  }

  /// Saves an edit opened from Profile and returns there.
  Future<void> saveEdit() async {
    if (!canContinue || isSaving.value) {
      return;
    }
    isSaving.value = true;
    try {
      await _profiles.save(draft);
      Get.back<void>();
      KaloriToast.showSuccess(
        title: 'Targets updated',
        message: 'Your daily target is now ${HistoryFormat.number(_profiles.targets.value.calories)} kcal.',
      );
    } finally {
      isSaving.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Field updates
  // ---------------------------------------------------------------------------

  void changeAge(int delta) => age.value = (age.value + delta).clamp(minAge, maxAge);

  void setHeight(double cm) => heightCm.value = cm.clamp(minHeightCm, maxHeightCm);

  void setWeight(double kg) => weightKg.value = kg.clamp(minWeightKg, maxWeightKg);

  void setWeightInLb(bool value) {
    weightInLb.value = value;
    _syncTargetText();
  }

  void setGoal(GoalType value) {
    goal.value = value;
    _ensureSensibleTarget();
  }

  void _ensureSensibleTarget() {
    final w = weightKg.value;
    final t = targetWeightKg.value;
    if (goal.value == GoalType.lose && t >= w) {
      targetWeightKg.value = _roundHalf(w * 0.9);
    } else if (goal.value == GoalType.gain && t <= w) {
      targetWeightKg.value = _roundHalf(w * 1.08);
    }
    _syncTargetText();
  }

  void _onTargetTyped() {
    final parsed = double.tryParse(targetController.text.replaceAll(',', '.'));
    if (parsed == null) {
      targetWeightKg.value = 0;
      return;
    }
    targetWeightKg.value = weightInLb.value ? parsed * kgPerLb : parsed;
  }

  void _syncTargetText() {
    final display = weightInLb.value ? targetWeightKg.value / kgPerLb : targetWeightKg.value;
    final text = _trimZero(display);
    if (targetController.text != text) {
      targetController.text = text;
    }
  }

  // ---------------------------------------------------------------------------
  // Formatting
  // ---------------------------------------------------------------------------

  String formatWeight(double kg) {
    return weightInLb.value ? '${_trimZero(kg / kgPerLb)} lb' : '${_trimZero(kg)} kg';
  }

  /// Weekly pace, e.g. `0.25 kg` or `0.55 lb` (two decimals so 0.25 / 0.75 aren't rounded).
  String formatPace(double kgPerWeek) {
    final v = weightInLb.value ? kgPerWeek / kgPerLb : kgPerWeek;
    final text = v.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
    return '$text ${weightInLb.value ? 'lb' : 'kg'}';
  }

  /// `175` (cm) or `5′ 9″`.
  String formatHeightValue(double cm) {
    if (!heightInFeet.value) {
      return cm.round().toString();
    }
    final totalInches = (cm / 2.54).round();
    return '${totalInches ~/ 12}′ ${totalInches % 12}″';
  }

  static double _roundHalf(double v) => (v * 2).round() / 2;

  static String _trimZero(double v) {
    final rounded = (v * 10).round() / 10;
    return rounded == rounded.roundToDouble() ? rounded.round().toString() : rounded.toStringAsFixed(1);
  }
}
