import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/more/presentation/widgets/more_sheet.dart';

/// Bottom navigation (google_nav_bar) with the pull-up "More" handle on its top edge.
///
/// The selected tab expands into a soft green pill showing its label; the others
/// show icons only, which keeps the bar uncluttered.
class KaloriBottomNavBar extends StatelessWidget {
  final HomeController controller;

  const KaloriBottomNavBar({super.key, required this.controller});

  static const double handleHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The handle sits in its own strip (inside the nav's bounds so it stays tappable).
        const SizedBox(height: handleHeight, child: Align(alignment: Alignment.bottomCenter, child: MoreHandle())),
        DecoratedBox(
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            border: Border(top: BorderSide(color: KaloriColors.borderSlate)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md, vertical: 10.0),
              child: Obx(
                () => GNav(
                  selectedIndex: controller.currentTab.value,
                  onTabChange: controller.changeTab,
                  gap: 8.0,
                  iconSize: 24.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  tabBorderRadius: 9999.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  color: KaloriColors.outline,
                  activeColor: KaloriColors.primary,
                  tabBackgroundColor: KaloriColors.successTint,
                  rippleColor: KaloriColors.surfaceContainerHigh,
                  hoverColor: KaloriColors.surfaceContainerLow,
                  textStyle: context.typography.bodySm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: KaloriColors.primary,
                  ),
                  tabs: const [
                    GButton(icon: Icons.home_rounded, text: 'Home', semanticLabel: 'Home'),
                    GButton(icon: Icons.add_circle_outline_rounded, text: 'Log', semanticLabel: 'Log'),
                    GButton(icon: Icons.history_rounded, text: 'History', semanticLabel: 'History'),
                    GButton(icon: Icons.person_outline_rounded, text: 'Profile', semanticLabel: 'Profile'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
