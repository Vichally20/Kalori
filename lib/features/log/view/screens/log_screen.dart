import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/view/controllers/home_controller.dart';
import '../../../home/view/widgets/kalori_bottom_nav_bar.dart';
import '../controllers/log_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/log_floating_input_bar.dart';
import '../widgets/meal_breakdown_card.dart';
import '../widgets/suggestion_chips_row.dart';

class LogView extends StatelessWidget {
  const LogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure LogController is available whether accessed via tab switch or direct navigation
    final LogController controller = Get.isRegistered<LogController>()
        ? Get.find<LogController>()
        : Get.put(LogController());

    final bool isStandaloneRoute = Get.currentRoute == AppRoutes.log;

    final Widget content = SafeArea(
      child: Column(
        children: [
          // Main Scrollable Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: KaloriSpacing.containerMargin,
                right: KaloriSpacing.containerMargin,
                top: KaloriSpacing.md,
                bottom: KaloriSpacing.md,
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

                  // Chat Messages Area
                  Obx(
                    () => Column(
                      children: controller.chatMessages.map((message) {
                        return ChatBubble(message: message);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: KaloriSpacing.sm),

                  // Contractible Meal Breakdown Card
                  Obx(
                    () => Column(
                      children: [
                        MealBreakdownCard(
                          foodItems: controller.foodItems,
                          carbs: controller.carbsCurrent.value,
                          protein: controller.proteinCurrent.value,
                          fat: controller.fatCurrent.value,
                          onClose: controller.contractMealBreakdown,
                          isExpanded: controller.isMealBreakdownExpanded.value,
                          onToggleExpand: controller.toggleMealBreakdown,
                        ),
                        const SizedBox(height: KaloriSpacing.lg),
                      ],
                    ),
                  ),

                  // Quick Suggestion Chips (ADD BLACK COFFEE, etc.)
                  SuggestionChipsRow(
                    suggestions: const [
                      'ADD BLACK COFFEE',
                      'ADD OAT MILK LATTE',
                      'ADD ESPRESSO',
                      'ADD AVOCADO',
                      'EDIT MEAL',
                    ],
                    onChipTap: controller.addSuggestion,
                  ),
                ],
              ),
            ),
          ),

          // Pinned Chat Bar right at the bottom of the screen
          Container(
            padding: const EdgeInsets.only(
              left: KaloriSpacing.containerMargin,
              right: KaloriSpacing.containerMargin,
              top: 8.0,
              bottom: 12.0,
            ),
            decoration: const BoxDecoration(
              color: KaloriColors.background,
            ),
            child: LogFloatingInputBar(controller: controller),
          ),
        ],
      ),
    );

    if (!isStandaloneRoute) {
      return Scaffold(
        backgroundColor: KaloriColors.background,
        body: content,
      );
    }

    return Scaffold(
      backgroundColor: KaloriColors.background,
      body: content,
      bottomNavigationBar: Get.isRegistered<HomeController>()
          ? KaloriBottomNavBar(controller: Get.find<HomeController>())
          : null,
    );
  }
}
