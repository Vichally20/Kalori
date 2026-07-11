import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class KaloriBottomNavBar extends StatelessWidget {
  final HomeController controller;

  const KaloriBottomNavBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: KaloriColors.borderSlate, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final int currentIndex = controller.currentTab.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _buildNavItem(
                context: context,
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.add_circle_outline,
                activeIcon: Icons.add_circle,
                label: 'Log',
              ),
              _buildNavItem(
                context: context,
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'History',
              ),
              _buildNavItem(
                context: context,
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active Green Pill around Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: isSelected ? KaloriColors.successGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? KaloriColors.onPrimaryContainer : KaloriColors.outline,
                size: 24.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: context.typography.labelCaps.copyWith(
                color: isSelected ? KaloriColors.onSurface : KaloriColors.outline,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
