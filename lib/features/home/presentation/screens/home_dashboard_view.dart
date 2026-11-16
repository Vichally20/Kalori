import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/utils/day_status_style.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/home/presentation/widgets/recent_logs_section.dart';
import 'package:kalori/features/home/presentation/widgets/tip_of_the_day_card.dart';
import 'package:kalori/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:kalori/shared/shared.dart';

class HomeDashboardView extends GetView<HomeController> {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: KaloriSpacing.containerMargin,
          vertical: KaloriSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Row: Calendar + Notification Bell + Profile Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: KaloriColors.successGreen,
                      size: 24.0,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Today, ${HistoryFormat.shortDate(DateTime.now())}',
                      style: context.typography.headlineMd.copyWith(
                        color: KaloriColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildNotificationBell(),
                    const SizedBox(width: 12.0),
                    Semantics(
                      button: true,
                      label: 'Profile',
                      excludeSemantics: true,
                      child: GestureDetector(
                        onTap: () => controller.changeTab(3),
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: KaloriColors.primaryFixed,
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: KaloriColors.surfaceContainerHighest,
                            child: Obx(
                              () => controller.initials.isEmpty
                                  ? Icon(Icons.person, color: KaloriColors.primary, size: 24.0)
                                  : Text(
                                      controller.initials,
                                      style: context.typography.bodySm.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: KaloriColors.primary,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: KaloriSpacing.lg),

            // Main Calorie Ring Card
            Obx(() {
              final summary = controller.todaySummary;
              final targets = controller.targets;
              final remaining = controller.remainingCalories;
              final style = DayStatusStyle.of(controller.todayStatus);
              double share(int value, int goal) => goal <= 0 ? 0 : value / goal;
              return GenericCalorieRingWidget(
                progressPercent: summary.progress,
                centerLabel: remaining >= 0 ? 'REMAINING' : 'OVER BY',
                centerValue: HistoryFormat.number(remaining.abs()),
                progressColor: style.fill,
                badgeText: style.label,
                badgeIcon: style.icon,
                badgeBgColor: style.badgeBg,
                badgeTextColor: style.badgeFg,
                macros: [
                  MacroData(
                    label: 'CARBS',
                    valueText: '${summary.carbs}g',
                    progress: share(summary.carbs, targets.carbs),
                    color: KaloriColors.tertiary,
                    trackColor: KaloriColors.surfaceContainerHigh,
                  ),
                  MacroData(
                    label: 'PROTEIN',
                    valueText: '${summary.protein}g',
                    progress: share(summary.protein, targets.protein),
                    color: KaloriColors.primary,
                    trackColor: KaloriColors.surfaceContainerHighest,
                  ),
                  MacroData(
                    label: 'FAT',
                    valueText: '${summary.fat}g',
                    progress: share(summary.fat, targets.fat),
                    color: KaloriColors.secondary,
                    trackColor: KaloriColors.secondaryFixed,
                  ),
                ],
              );
            }),
            const SizedBox(height: KaloriSpacing.md),

            // Quick stats: all from real sources (meals, water, streak).
            Obx(
              () => GenericQuickStatsRow(
                stats: [
                  StatCardData(
                    label: 'EATEN',
                    value: HistoryFormat.number(controller.todaySummary.calories),
                    icon: Icons.restaurant_outlined,
                    iconColor: KaloriColors.primary,
                    onTap: () => controller.changeTab(1),
                  ),
                  StatCardData(
                    label: 'WATER',
                    value: '${controller.waterGlasses}/${controller.waterGoal}',
                    icon: Icons.water_drop_outlined,
                    iconColor: KaloriColors.tertiary,
                    onTap: () => Get.toNamed<void>(AppRoutes.water),
                  ),
                  StatCardData(
                    label: 'STREAK',
                    value: '${controller.streak}',
                    icon: Icons.local_fire_department_outlined,
                    iconColor: KaloriColors.secondary,
                    onTap: () => controller.changeTab(2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: KaloriSpacing.md),

            // Tip of the Day Dark Card
            const TipOfTheDayCard(),
            const SizedBox(height: KaloriSpacing.lg),

            // Recent Logs Section
            Obx(
              () => RecentLogsSection(
                logs: controller.recentLogs,
                onViewAll: () => controller.changeTab(2), // Full history lives in the History tab
              ),
            ),
            // Bottom spacing so content can scroll under floating chat widget
            const SizedBox(height: 90.0),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    if (!Get.isRegistered<NotificationsController>()) {
      return const SizedBox.shrink();
    }
    final notifCtrl = Get.find<NotificationsController>();
    return Obx(() {
      final unread = notifCtrl.unreadCount;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () => Get.toNamed<dynamic>(AppRoutes.notifications),
            borderRadius: KaloriRadius.borderFull,
            child: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: KaloriColors.surfaceContainerHigh,
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: KaloriColors.onSurface,
                size: 24.0,
              ),
            ),
          ),
          if (unread > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: KaloriColors.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    '$unread',
                    style: TextStyle(
                      color: KaloriColors.onError,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
