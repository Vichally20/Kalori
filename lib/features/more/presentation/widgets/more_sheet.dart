import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/water_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/shared/shared.dart';

/// Pull-up tab on the bottom nav's top edge. Swipe up or tap to open [MoreSheet].
class MoreHandle extends StatelessWidget {
  const MoreHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'More features',
      hint: 'Swipe up or double tap to open',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => MoreSheet.show(context),
        onVerticalDragUpdate: (d) {
          if (d.delta.dy < -4) {
            MoreSheet.show(context);
          }
        },
        child: Container(
          width: 84.0,
          height: 24.0,
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14.0)),
            border: Border(
              top: BorderSide(color: KaloriColors.borderSlate),
              left: BorderSide(color: KaloriColors.borderSlate),
              right: BorderSide(color: KaloriColors.borderSlate),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_arrow_up_rounded, size: 18.0, color: KaloriColors.primary),
              const SizedBox(width: 2.0),
              Text(
                'MORE',
                style: context.typography.labelCaps.copyWith(fontSize: 11.0, height: 14.0 / 11.0, color: KaloriColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet listing Kalori's small extra tools ("nano features").
class MoreSheet extends StatelessWidget {
  const MoreSheet({super.key});

  static bool _open = false;

  static Future<void> show(BuildContext context) async {
    if (_open) {
      return;
    }
    _open = true;
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
        backgroundColor: KaloriColors.background,
        barrierColor: KaloriColors.scrim,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
        builder: (_) => const MoreSheet(),
      );
    } finally {
      _open = false;
    }
  }

  void _comingSoon(String feature) {
    KaloriToast.showInfo(title: '$feature is coming soon', message: "We're still building this part of Kalori.");
  }

  void _openRoute(BuildContext context, String route) {
    Navigator.of(context).pop();
    Get.toNamed<void>(route);
  }

  @override
  Widget build(BuildContext context) {
    final water = Get.find<WaterService>();
    return FractionallySizedBox(
      heightFactor: 0.82,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 10.0, KaloriSpacing.containerMargin, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.0,
                height: 5.0,
                decoration: BoxDecoration(color: KaloriColors.outlineVariant, borderRadius: KaloriRadius.borderFull),
              ),
            ),
            const SizedBox(height: KaloriSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text('More in Kalori', style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 2.0),
                      Text('Small tools that work alongside your food log.', style: context.typography.bodySm),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(backgroundColor: KaloriColors.surfaceContainerHigh),
                  icon: Icon(Icons.close_rounded, size: 20.0, color: KaloriColors.onSurface),
                ),
              ],
            ),
            const SizedBox(height: KaloriSpacing.md),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: KaloriSpacing.gutter,
                crossAxisSpacing: KaloriSpacing.gutter,
                childAspectRatio: 1.05,
                padding: const EdgeInsets.only(bottom: KaloriSpacing.lg),
                children: [
                  Obx(
                    () => _FeatureTile(
                      icon: Icons.water_drop_outlined,
                      iconBg: KaloriColors.tertiaryFixed,
                      iconColor: KaloriColors.tertiary,
                      title: 'Water',
                      status: '${water.today} of ${water.goal.value} glasses',
                      progress: water.goal.value == 0 ? 0 : water.today / water.goal.value,
                      action: _TileAction(label: '+1 glass', onPressed: water.addGlass),
                      onTap: () => _openRoute(context, AppRoutes.water),
                    ),
                  ),
                  _FeatureTile(
                    icon: Icons.menu_book_outlined,
                    iconBg: KaloriColors.macroFatBg,
                    iconColor: KaloriColors.secondary,
                    title: 'Food dictionary',
                    status: 'Look up calories in local dishes.',
                    comingSoon: true,
                    onTap: () => _comingSoon('Food dictionary'),
                  ),
                  _FeatureTile(
                    icon: Icons.event_note_outlined,
                    iconBg: KaloriColors.successTint,
                    iconColor: KaloriColors.primary,
                    title: 'Meal timetable',
                    status: 'Plan when you eat each day.',
                    comingSoon: true,
                    onTap: () => _comingSoon('Meal timetable'),
                  ),
                  _FeatureTile(
                    icon: Icons.fitness_center_rounded,
                    iconBg: KaloriColors.surfaceContainerHigh,
                    iconColor: KaloriColors.onSurface,
                    title: 'Gym',
                    status: 'Log workouts and sets.',
                    comingSoon: true,
                    onTap: () => _comingSoon('Gym tracking'),
                  ),
                  _FeatureTile(
                    icon: Icons.directions_walk_rounded,
                    iconBg: KaloriColors.secondaryFixed,
                    iconColor: KaloriColors.onSecondaryFixedVariant,
                    title: 'Daily steps',
                    status: 'Sync steps from your health app.',
                    comingSoon: true,
                    onTap: () => _comingSoon('Step tracking'),
                  ),
                  _FeatureTile(
                    icon: Icons.medication_outlined,
                    iconBg: KaloriColors.errorContainer,
                    iconColor: KaloriColors.onErrorContainer,
                    title: 'Medication',
                    status: 'Reminders for pills and supplements.',
                    comingSoon: true,
                    onTap: () => _comingSoon('Medication reminders'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileAction {
  final String label;
  final VoidCallback onPressed;

  const _TileAction({required this.label, required this.onPressed});
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String status;
  final double? progress;
  final _TileAction? action;
  final bool comingSoon;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.status,
    required this.onTap,
    this.progress,
    this.action,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: KaloriColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: KaloriRadius.borderLg,
        side: BorderSide(color: KaloriColors.borderSlate),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(color: iconBg, borderRadius: KaloriRadius.borderMd),
                    child: Icon(icon, size: 22.0, color: iconColor),
                  ),
                  const Spacer(),
                  if (action != null)
                    FilledButton(
                      onPressed: action!.onPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: KaloriColors.tertiary,
                        minimumSize: const Size(0, 36.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        textStyle: context.typography.labelCaps.copyWith(letterSpacing: 0.2),
                      ),
                      child: Text(action!.label),
                    )
                  else if (comingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(color: KaloriColors.surfaceContainerHigh, borderRadius: KaloriRadius.borderFull),
                      child: Text(
                        'SOON',
                        style: context.typography.labelCaps.copyWith(
                          fontSize: 10.0,
                          height: 14.0 / 10.0,
                          letterSpacing: 0.5,
                          color: KaloriColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(title, style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.onSurface)),
              const SizedBox(height: 2.0),
              Text(
                status,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodySm.copyWith(fontSize: 13.0, height: 18.0 / 13.0, color: KaloriColors.onSurfaceVariant),
              ),
              if (progress != null) ...[
                const SizedBox(height: KaloriSpacing.xs),
                ClipRRect(
                  borderRadius: KaloriRadius.borderFull,
                  child: LinearProgressIndicator(
                    value: progress!.clamp(0.0, 1.0),
                    minHeight: 6.0,
                    backgroundColor: KaloriColors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation<Color>(KaloriColors.tertiary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
