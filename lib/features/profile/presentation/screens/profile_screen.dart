import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/core/utilities/constants.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:kalori/features/profile/domain/entities/daily_targets.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/presentation/controllers/profile_controller.dart';
import 'package:kalori/features/profile/presentation/widgets/weight_sparkline.dart';

/// Profile tab: identity, habits, weight goal, daily targets and settings.
class ProfileView extends GetView<ProfileController> {
  static String path = '/profile';

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      body: SafeArea(
        child: Obx(() {
          final profile = controller.profile;
          if (profile == null) {
            return _NoProfile(onStart: controller.startOnboarding);
          }
          final targets = controller.targets;
          final stats = controller.allTime;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              KaloriSpacing.containerMargin,
              KaloriSpacing.md,
              KaloriSpacing.containerMargin,
              KaloriSpacing.lg,
            ),
            children: [
              SizedBox(
                height: 44.0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Profile', style: context.typography.headlineLgMobile),
                ),
              ),
              const SizedBox(height: KaloriSpacing.containerMargin),
              _IdentityRow(profile: profile, onEdit: controller.editName),
              const SizedBox(height: KaloriSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'STREAK',
                      value: '${controller.streak}',
                      caption: controller.streak == 1 ? 'day' : 'days',
                    ),
                  ),
                  const SizedBox(width: KaloriSpacing.gutter),
                  Expanded(
                    child: _StatTile(
                      label: 'LOGGED',
                      value: '${stats?.loggedDays ?? 0}',
                      caption: (stats?.loggedDays ?? 0) == 1 ? 'day total' : 'days total',
                    ),
                  ),
                  const SizedBox(width: KaloriSpacing.gutter),
                  Expanded(
                    child: _StatTile(label: 'ON TRACK', value: '${controller.onTrackPercent}%', caption: 'of days'),
                  ),
                ],
              ),
              const SizedBox(height: KaloriSpacing.md),
              _TargetsCard(targets: targets, onEdit: () => controller.editStep(OnboardingStep.goal)),
              const SizedBox(height: KaloriSpacing.md),
              _WeightCard(profile: profile, onLog: controller.openWeightLog),
              const _SectionLabel('BODY & GOAL'),
              _SettingsGroup(
                children: [
                  _SettingsRow(
                    title: 'Name, sex & age',
                    value: '${profile.sex == Sex.male ? 'Male' : 'Female'}, ${profile.age}',
                    onTap: () => controller.editStep(OnboardingStep.about),
                  ),
                  _SettingsRow(
                    title: 'Height & weight',
                    value: '${profile.heightCm.round()} cm · ${_kg(profile.weightKg)}',
                    onTap: () => controller.editStep(OnboardingStep.body),
                  ),
                  _SettingsRow(
                    title: 'Activity',
                    value: profile.activity.label,
                    onTap: () => controller.editStep(OnboardingStep.activity),
                  ),
                  _SettingsRow(
                    title: 'Goal',
                    value: _goalText(profile),
                    onTap: () => controller.editStep(OnboardingStep.goal),
                  ),
                ],
              ),
              const _SectionLabel('APP'),
              _SettingsGroup(
                children: [
                  _SwitchRow(
                    icon: Icons.alarm_rounded,
                    iconColor: KaloriColors.primary,
                    title: 'Meal reminders',
                    value: profile.mealRemindersEnabled,
                    onChanged: controller.setMealReminders,
                  ),
                  _SettingsRow(
                    icon: Icons.dark_mode_outlined,
                    iconColor: KaloriColors.onSurfaceVariant,
                    title: 'Appearance',
                    value: controller.appearanceLabel,
                    onTap: controller.chooseAppearance,
                  ),
                  _SettingsRow(
                    icon: Icons.water_drop_outlined,
                    iconColor: KaloriColors.tertiary,
                    title: 'Water tracker',
                    value: '${controller.waterToday} of ${controller.waterGoal} today',
                    onTap: controller.openWater,
                  ),
                  _SettingsRow(
                    icon: Icons.monitor_heart_outlined,
                    iconColor: KaloriColors.secondary,
                    title: 'Health apps',
                    value: 'Not connected',
                    onTap: () => controller.comingSoon('Health app sync'),
                  ),
                ],
              ),
              const _SectionLabel('SUPPORT'),
              _SettingsGroup(
                children: [
                  _SettingsRow(title: 'Help & feedback', onTap: () => controller.comingSoon('Help & feedback')),
                  _SettingsRow(title: 'Privacy policy', onTap: () => controller.comingSoon('Privacy policy')),
                  _SettingsRow(title: 'Terms of service', onTap: () => controller.comingSoon('Terms of service')),
                ],
              ),
              const SizedBox(height: KaloriSpacing.containerMargin),
              TextButton(
                onPressed: controller.resetAllData,
                style: TextButton.styleFrom(
                  foregroundColor: KaloriColors.error,
                  minimumSize: const Size.fromHeight(48.0),
                ),
                child: Text(
                  'Reset all data',
                  style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.error),
                ),
              ),
              Text(
                'Kalori ${Constants.appVersion} · data stored on this phone',
                textAlign: TextAlign.center,
                style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
              ),
            ],
          );
        }),
      ),
    );
  }

  static String _kg(double v) {
    final r = (v * 10).round() / 10;
    return '${r == r.roundToDouble() ? r.round() : r.toStringAsFixed(1)} kg';
  }

  static String _goalText(UserProfile p) {
    return switch (p.goal) {
      GoalType.lose => 'Lose ${p.pace.kgPerWeek} kg / week',
      GoalType.gain => 'Gain ${p.pace.kgPerWeek} kg / week',
      GoalType.maintain => 'Maintain weight',
    };
  }
}

class _IdentityRow extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEdit;

  const _IdentityRow({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64.0,
          height: 64.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: KaloriColors.surfaceContainerHighest,
            border: Border.all(color: KaloriColors.primaryFixed, width: 3.0),
          ),
          child: ExcludeSemantics(
            child: Text(
              profile.initials,
              style: context.typography.headlineMd.copyWith(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: KaloriColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: KaloriSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name.isEmpty ? 'Your profile' : profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Logging since ${HistoryFormat.shortMonthYear(profile.createdAt)}',
                style: context.typography.bodySm.copyWith(color: KaloriColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Edit name',
          onPressed: onEdit,
          style: IconButton.styleFrom(
            backgroundColor: KaloriColors.surfaceContainerHigh,
            fixedSize: const Size(44.0, 44.0),
          ),
          icon: Icon(Icons.edit_outlined, size: 20.0, color: KaloriColors.onSurface),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String caption;

  const _StatTile({required this.label, required this.value, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: KaloriSpacing.sm, horizontal: KaloriSpacing.xs),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
      ),
      child: Column(
        children: [
          Text(label, style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
          const SizedBox(height: 2.0),
          Text(value, style: context.typography.headlineLgMobile),
          Text(caption, style: context.typography.bodySm.copyWith(fontSize: 12.0, height: 16.0 / 12.0)),
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onLog;

  const _WeightCard({required this.profile, required this.onLog});

  @override
  Widget build(BuildContext context) {
    final change = profile.weightKg - profile.startWeightKg;
    final isMaintain = profile.goal == GoalType.maintain;
    final totalToMove = (profile.startWeightKg - profile.targetWeightKg).abs();
    final moved = profile.goal == GoalType.lose ? -change : change;
    final progress = totalToMove == 0 ? 0.0 : (moved / totalToMove).clamp(0.0, 1.0);
    final toGo = (profile.weightKg - profile.targetWeightKg).abs();
    final startDate = profile.weightLog.isEmpty ? profile.createdAt : profile.weightLog.first.date;
    final points = profile.weightLog.length > 12
        ? profile.weightLog.sublist(profile.weightLog.length - 12)
        : profile.weightLog;

    final changeText = change.abs() < 0.05
        ? 'No change since ${HistoryFormat.shortDate(startDate)}'
        : '${change < 0 ? '−' : '+'}${ProfileView._kg(change.abs())} since ${HistoryFormat.shortDate(startDate)}';
    final changeGood = (profile.goal == GoalType.lose && change < 0) || (profile.goal == GoalType.gain && change > 0);

    return Container(
      padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 18.0, KaloriSpacing.containerMargin, 18.0),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
        boxShadow: [BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT WEIGHT',
                      style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
                    ),
                    Text.rich(
                      TextSpan(
                        text: ProfileView._kg(profile.weightKg).replaceAll(' kg', ''),
                        style: context.typography.headlineLg.copyWith(fontSize: 36.0, height: 44.0 / 36.0),
                        children: [TextSpan(text: ' kg', style: context.typography.bodySm)],
                      ),
                    ),
                    Text(
                      changeText,
                      style: context.typography.bodySm.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: changeGood ? KaloriColors.primary : KaloriColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (points.length >= 2)
                Semantics(
                  label: 'Weight trend from ${ProfileView._kg(points.first.kg)} to ${ProfileView._kg(points.last.kg)}',
                  excludeSemantics: true,
                  child: WeightSparkline(values: [for (final p in points) p.kg]),
                ),
            ],
          ),
          if (!isMaintain) ...[
            const SizedBox(height: 14.0),
            ClipRRect(
              borderRadius: KaloriRadius.borderFull,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.0,
                backgroundColor: KaloriColors.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(KaloriColors.successGreen),
              ),
            ),
            const SizedBox(height: 6.0),
            DefaultTextStyle(
              style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
              child: Row(
                children: [
                  Text('Start ${ProfileView._kg(profile.startWeightKg)}'),
                  Expanded(
                    child: Text(
                      toGo < 0.05 ? 'Goal reached' : '${ProfileView._kg(toGo)} to go',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text('Goal ${ProfileView._kg(profile.targetWeightKg)}'),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14.0),
          OutlinedButton.icon(
            onPressed: onLog,
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44.0)),
            icon: const Icon(Icons.add_rounded, size: 18.0),
            label: const Text("Log today's weight"),
          ),
        ],
      ),
    );
  }
}

class _TargetsCard extends StatelessWidget {
  final DailyTargets targets;
  final VoidCallback onEdit;

  const _TargetsCard({required this.targets, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    TextSpan macro(String grams, String label) => TextSpan(
          children: [
            TextSpan(
              text: '$grams\n',
              style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            ),
            TextSpan(text: label),
          ],
        );

    final muted = context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.outlineVariant);
    return Container(
      padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 14.0, KaloriSpacing.xs, 18.0),
      decoration: BoxDecoration(color: KaloriColors.inverseSurface, borderRadius: KaloriRadius.borderLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'DAILY TARGETS',
                  style: context.typography.labelCaps.copyWith(color: KaloriColors.inversePrimary),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(foregroundColor: KaloriColors.inversePrimary),
                child: Text('EDIT', style: context.typography.labelCaps.copyWith(color: KaloriColors.inversePrimary)),
              ),
            ],
          ),
          Text.rich(
            TextSpan(
              text: HistoryFormat.number(targets.calories),
              style: context.typography.headlineLg.copyWith(color: Colors.white),
              children: [TextSpan(text: ' kcal a day', style: muted.copyWith(fontSize: 14.0))],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(right: KaloriSpacing.md),
            child: Row(
              children: [
                Expanded(child: Text.rich(macro('${targets.protein}g', 'protein'), style: muted)),
                Expanded(child: Text.rich(macro('${targets.carbs}g', 'carbs'), style: muted)),
                Expanded(child: Text.rich(macro('${targets.fat}g', 'fat'), style: muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, KaloriSpacing.lg, 4.0, KaloriSpacing.xs),
      child: Semantics(
        header: true,
        child: Text(text, style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(color: KaloriColors.borderSlate, height: 1.0, indent: 16.0, endIndent: 16.0),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _SettingsRow({required this.title, required this.onTap, this.value, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.0, color: iconColor),
                const SizedBox(width: KaloriSpacing.sm),
              ],
              Expanded(
                child: Text(title, style: context.typography.bodyLg.copyWith(color: KaloriColors.onSurface)),
              ),
              if (value != null)
                Flexible(
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: context.typography.bodySm.copyWith(color: KaloriColors.onSurfaceVariant),
                  ),
                ),
              const SizedBox(width: 4.0),
              Icon(Icons.chevron_right_rounded, color: KaloriColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: SizedBox(
        height: 52.0,
        child: Padding(
          padding: const EdgeInsets.only(left: KaloriSpacing.md, right: KaloriSpacing.xs),
          child: Row(
            children: [
              Icon(icon, size: 20.0, color: iconColor),
              const SizedBox(width: KaloriSpacing.sm),
              Expanded(
                child: Text(title, style: context.typography.bodyLg.copyWith(color: KaloriColors.onSurface)),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: KaloriColors.successGreen,
                activeThumbColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoProfile extends StatelessWidget {
  final VoidCallback onStart;

  const _NoProfile({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Set up your profile', style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: KaloriSpacing.xs),
            Text(
              'Tell us a little about you to get a personal daily target.',
              textAlign: TextAlign.center,
              style: context.typography.bodySm,
            ),
            const SizedBox(height: KaloriSpacing.lg),
            ElevatedButton(onPressed: onStart, child: const Text('Get started')),
          ],
        ),
      ),
    );
  }
}
