import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/home/presentation/controllers/home_controller.dart';
import 'package:kalori/features/home/presentation/widgets/kalori_bottom_nav_bar.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';
import 'package:kalori/features/log/presentation/controllers/log_controller.dart';
import 'package:kalori/features/log/presentation/widgets/chat_bubble.dart';
import 'package:kalori/features/log/presentation/widgets/log_floating_input_bar.dart';
import 'package:kalori/features/log/presentation/widgets/meal_breakdown_card.dart';
import 'package:kalori/features/log/presentation/widgets/suggestion_chips_row.dart';

class LogView extends StatelessWidget {
  static String path = '/log';

  const LogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure LogController is available whether accessed via tab switch or direct navigation
    final LogController controller = Get.isRegistered<LogController>()
        ? Get.find<LogController>()
        : Get.put(LogController());
    final UserProfileService profiles = Get.find<UserProfileService>();

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
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: KaloriColors.primaryFixed, width: 2.5),
                        ),
                        child: CircleAvatar(
                          backgroundColor: KaloriColors.surfaceContainerHighest,
                          child: Obx(() {
                            final initials = profiles.profile.value?.initials ?? '';
                            return initials.isEmpty
                                ? Icon(Icons.person, color: KaloriColors.primary, size: 24.0)
                                : Text(
                                    initials,
                                    style: context.typography.bodySm.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: KaloriColors.primary,
                                    ),
                                  );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KaloriSpacing.lg),

                  // Chat Messages Area
                  Obx(() {
                    if (controller.chatMessages.isEmpty) {
                      // Greeting shown until the first message; not stored in the chat.
                      final name = profiles.profile.value?.firstName;
                      return ChatBubble(
                        message: ChatMessage(
                          text:
                              'Hi${name == null ? '' : ' $name'}! Tell me what you ate, like '
                              '"jollof rice and chicken" or "2 boiled eggs", and I\'ll work out the calories.',
                          isUser: false,
                        ),
                      );
                    }
                    return Column(
                      children: controller.chatMessages.map((message) {
                        return ChatBubble(message: message);
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: KaloriSpacing.sm),

                  // Contractible Meal Breakdown Card (today's meals only)
                  Obx(
                    () => controller.todayEntries.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              MealBreakdownCard(
                                mealEntries: controller.todayEntries,
                                totalCalories: controller.totalCalories,
                                carbs: controller.totalCarbs,
                                protein: controller.totalProtein,
                                fat: controller.totalFat,
                                onClose: controller.contractMealBreakdown,
                                isExpanded: controller.isMealBreakdownExpanded.value,
                                onToggleExpand: controller.toggleMealBreakdown,
                              ),
                              const SizedBox(height: KaloriSpacing.lg),
                            ],
                          ),
                  ),

                  // Quick Suggestion Chips
                  Obx(
                    () => SuggestionChipsRow(
                      suggestions: controller.frequentSuggestions.toList(),
                      onChipTap: controller.addSuggestion,
                    ),
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
            decoration: BoxDecoration(color: KaloriColors.background),
            child: LogFloatingInputBar(controller: controller),
          ),
        ],
      ),
    );

    if (!isStandaloneRoute) {
      return Scaffold(backgroundColor: KaloriColors.background, body: content);
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
