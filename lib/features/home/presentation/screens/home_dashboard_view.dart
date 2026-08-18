import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/theme/app_theme.dart';
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
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: KaloriColors.successGreen,
                      size: 24.0,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Today, Oct 24',
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
                    GestureDetector(
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
                        child: const CircleAvatar(
                          backgroundColor: KaloriColors.surfaceContainerHighest,
                          child: Icon(
                            Icons.person,
                            color: KaloriColors.primary,
                            size: 24.0,
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
            Obx(
              () => GenericCalorieRingWidget(
                remainingCalories: controller.remainingCalories.value,
                progressPercent: controller.progressPercent.value,
                carbsCurrent: controller.carbsCurrent.value,
                proteinCurrent: controller.proteinCurrent.value,
                fatCurrent: controller.fatCurrent.value,
              ),
            ),
            const SizedBox(height: KaloriSpacing.md),

            // Quick Stats Row (EATEN, BURNED, NET)
            Obx(
              () => GenericQuickStatsRow(
                eaten: controller.eatenCalories.value,
                burned: controller.burnedCalories.value,
                net: controller.netCalories.value,
              ),
            ),
            const SizedBox(height: KaloriSpacing.md),

            // Tip of the Day Dark Card
            const TipOfTheDayCard(),
            const SizedBox(height: KaloriSpacing.lg),

            // Recent Logs Section
            Obx(
              () => RecentLogsSection(
                logs: controller.recentLogs.toList(),
                onViewAll: () => controller.changeTab(1), // Switch to Log tab
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
              child: const Icon(
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
                decoration: const BoxDecoration(
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
                    style: const TextStyle(
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
