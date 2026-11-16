import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/log/domain/entities/meal_log_entry.dart';
import 'package:kalori/features/log/domain/entities/sync_status.dart';

class MealBreakdownCard extends StatelessWidget {
  final List<MealLogEntry> mealEntries;
  final int totalCalories;
  final int carbs;
  final int protein;
  final int fat;
  final VoidCallback onClose;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final void Function(MealLogEntry)? onRetry;

  const MealBreakdownCard({
    super.key,
    required this.mealEntries,
    required this.totalCalories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.onClose,
    this.isExpanded = true,
    this.onToggleExpand,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback toggleAction = onToggleExpand ?? onClose;

    // Contracted state: compact card with title and expand icon on the far right
    if (!isExpanded) {
      return GestureDetector(
        onTap: toggleAction,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(KaloriRadius.xl),
            border: Border.all(color: KaloriColors.borderSlate),
            boxShadow: [
              BoxShadow(
                color: KaloriColors.cardShadow,
                blurRadius: 16.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: KaloriSpacing.containerMargin,
            vertical: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_outlined,
                    color: KaloriColors.secondary,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Meal Breakdown • $totalCalories kcal',
                    style: context.typography.headlineMd.copyWith(
                      color: KaloriColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Far right expand icon
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: KaloriColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.0,
                  color: KaloriColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Expanded state: full meal breakdown card
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.xl),
        border: Border.all(color: KaloriColors.borderSlate),
        boxShadow: [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 24.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(KaloriSpacing.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with close/collapse button & LOGGED badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_outlined,
                    color: KaloriColors.secondary,
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
                      color: KaloriColors.successTint,
                      borderRadius: BorderRadius.circular(KaloriRadius.full),
                    ),
                    child: Text(
                      'LOGGED',
                      style: context.typography.labelCaps.copyWith(
                        color: KaloriColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Close/Collapse Button (contracts the card)
                  GestureDetector(
                    onTap: toggleAction,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: KaloriColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 20.0,
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
          ...mealEntries.asMap().entries.map((entryItem) {
            final int idx = entryItem.key;
            final MealLogEntry entry = entryItem.value;
            final bool isLast = idx == mealEntries.length - 1;
            
            final foodItem = entry.foodItem;

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
                              foodItem?.title ?? entry.rawInput,
                              style: context.typography.bodyLg.copyWith(
                                fontWeight: FontWeight.w700,
                                color: KaloriColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              foodItem?.subtitle ?? (entry.syncStatus == SyncStatus.pending ? 'Analyzing...' : (entry.syncStatus == SyncStatus.failed ? 'Failed to analyze' : 'Pending')),
                              style: context.typography.bodySm.copyWith(
                                color: entry.syncStatus == SyncStatus.failed ? Colors.red : KaloriColors.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (entry.syncStatus == SyncStatus.pending)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: KaloriColors.primary),
                          ),
                        )
                      else if (entry.syncStatus == SyncStatus.failed)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red, size: 20),
                          onPressed: () {
                            if (onRetry != null) onRetry!(entry);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      else if (foodItem != null)
                        Text(
                          '${foodItem.nutritionalInfo.calories} kcal',
                          style: context.typography.bodyLg.copyWith(
                            fontWeight: FontWeight.w700,
                            color: KaloriColors.onSurface,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(color: KaloriColors.borderSlate, height: 1.0),
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
                iconColor: KaloriColors.tertiary,
                bgColor: KaloriColors.macroCarbsBg,
                borderColor: Colors.transparent,
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              _buildMacroCard(
                context: context,
                label: 'PROTEIN',
                value: '${protein}g',
                icon: Icons.fitness_center_outlined,
                iconColor: KaloriColors.primary,
                bgColor: KaloriColors.macroProteinBg,
                borderColor: KaloriColors.primary, // Highlighted border
              ),
              const SizedBox(width: KaloriSpacing.gutter),
              _buildMacroCard(
                context: context,
                label: 'FAT',
                value: '${fat}g',
                icon: Icons.water_drop,
                iconColor: KaloriColors.secondary,
                bgColor: KaloriColors.macroFatBg,
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
