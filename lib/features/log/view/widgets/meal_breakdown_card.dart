import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/log_controller.dart';

class MealBreakdownCard extends StatelessWidget {
  final List<MealFoodItem> foodItems;
  final int carbs;
  final int protein;
  final int fat;
  final VoidCallback onClose;

  const MealBreakdownCard({
    super.key,
    required this.foodItems,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.xl),
        border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120D1C2F),
            blurRadius: 24.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(KaloriSpacing.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with closeable button & LOGGED badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.restaurant_outlined,
                    color: Color(0xFF855300),
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Meal Breakdown',
                    style: context.typography.headlineMd.copyWith(
                      color: KaloriColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // LOGGED Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F8F0),
                      borderRadius: BorderRadius.circular(KaloriRadius.full),
                    ),
                    child: Text(
                      'LOGGED',
                      style: context.typography.labelCaps.copyWith(
                        color: const Color(0xFF006C49),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Close Button (make the meal breakdown card closeable)
                  GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: KaloriColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18.0,
                        color: KaloriColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: KaloriSpacing.md),

          // Food Items List
          ...foodItems.asMap().entries.map((entry) {
            final int idx = entry.key;
            final MealFoodItem item = entry.value;
            final bool isLast = idx == foodItems.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: context.typography.bodyLg.copyWith(
                                fontWeight: FontWeight.w700,
                                color: KaloriColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: context.typography.bodySm.copyWith(
                                color: KaloriColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.calories,
                        style: context.typography.bodyLg.copyWith(
                          fontWeight: FontWeight.w700,
                          color: KaloriColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(color: KaloriColors.borderSlate, height: 1.0),
              ],
            );
          }),

          const SizedBox(height: KaloriSpacing.lg),

          // Bottom Macros Row (CARBS, PROTEIN, FAT cards)
          Row(
            children: [
              _buildMacroCard(
                context: context,
                label: 'CARBS',
                value: '${carbs}g',
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF005AC2),
                bgColor: const Color(0xFFEFF4FF),
                borderColor: Colors.transparent,
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              _buildMacroCard(
                context: context,
                label: 'PROTEIN',
                value: '${protein}g',
                icon: Icons.fitness_center_outlined,
                iconColor: const Color(0xFF006C49),
                bgColor: const Color(0xFFF1F5F9),
                borderColor: const Color(0xFF006C49), // Highlighted border
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              _buildMacroCard(
                context: context,
                label: 'FAT',
                value: '${fat}g',
                icon: Icons.water_drop,
                iconColor: const Color(0xFF855300),
                bgColor: const Color(0xFFFEF3C7),
                borderColor: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(KaloriRadius.lg),
          border: Border.all(
            color: borderColor != Colors.transparent
                ? borderColor
                : KaloriColors.borderSlate.withValues(alpha: 0.4),
            width: borderColor != Colors.transparent ? 1.5 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.0),
            const SizedBox(height: 6),
            Text(
              label,
              style: context.typography.labelCaps.copyWith(
                color: KaloriColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: context.typography.headlineLgMobile.copyWith(
                color: KaloriColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
