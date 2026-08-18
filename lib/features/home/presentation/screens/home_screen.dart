import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/screens/history_screen.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/home/presentation/screens/home_dashboard_view.dart';
import 'package:kalori/features/home/presentation/widgets/floating_chat_widget.dart';
import 'package:kalori/features/home/presentation/widgets/kalori_bottom_nav_bar.dart';
import 'package:kalori/features/log/presentation/screens/log_screen.dart';
import 'package:kalori/features/profile/presentation/screens/profile_screen.dart';

class HomeView extends GetView<HomeController> {
  static String path = '/home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        final currentId = controller.currentTab.value;
        final navigator = Get.nestedKey(currentId)?.currentState;

        if (navigator != null && navigator.canPop()) {
          navigator.pop();
        } else {
          if (currentId != 0) {
            controller.changeTab(0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: KaloriColors.background,
        body: Stack(
          children: [
            // Main Tab Body Content
            Obx(() {
              return IndexedStack(
                index: controller.currentTab.value,
                children: [
                  _TabNavigator(id: 0, page: () => const HomeDashboardView()),
                  _TabNavigator(id: 1, page: () => const LogView()),
                  _TabNavigator(id: 2, page: () => const HistoryView()),
                  _TabNavigator(id: 3, page: () => const ProfileView()),
                ],
              );
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
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  final int id;
  final Widget Function() page;

  const _TabNavigator({required this.id, required this.page});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(id),
      onGenerateRoute: (settings) {
        return GetPageRoute(
          page: page,
        );
      },
    );
  }
}
