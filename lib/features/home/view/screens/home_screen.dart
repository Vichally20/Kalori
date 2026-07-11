import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/shared.dart';
import '../../../history/view/screens/history_screen.dart';
import '../../../log/view/screens/log_screen.dart';
import '../../../profile/view/screens/profile_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/floating_chat_widget.dart';
import '../widgets/kalori_bottom_nav_bar.dart';
import '../widgets/recent_logs_section.dart';
import '../widgets/tip_of_the_day_card.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      body: Stack(
        children: [
          // Main Tab Body Content
          Obx(() {
            switch (controller.currentTab.value) {
              case 1:
                return const LogView();
              case 2:
                return const HistoryView();
              case 3:
                return const ProfileView();
              case 0:
              default:
                return _buildHomeDashboard(context);
            }
          }),

          // Floating Chat Widget at bottom of screen (above nav bar)
          Positioned(
            left: KaloriSpacing.md,
            right: KaloriSpacing.md,
            bottom: KaloriSpacing.md,
            child: Obx(() {
              // Show on Home tab (or customize if needed across tabs)
              if (controller.currentTab.value == 0) {
                return FloatingChatWidget(controller: controller);
              }
              return const SizedBox.shrink();
            }),
          ),
        ],
      ),
      bottomNavigationBar: KaloriBottomNavBar(controller: controller),
    );
  }

  Widget _buildHomeDashboard(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: KaloriSpacing.containerMargin,
          vertical: KaloriSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Row: Calendar + Profile Avatar
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
                Container(
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
}
