import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class RecentLogsSection extends StatelessWidget {
  final List<FoodLogItem> logs;
  final VoidCallback onViewAll;

  const RecentLogsSection({
    super.key,
    required this.logs,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(KaloriRadius.xl),
      ),
      padding: const EdgeInsets.all(KaloriSpacing.containerMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Logs',
                style: context.typography.headlineMd.copyWith(
                  color: KaloriColors.onSurface,
                ),
              ),
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(KaloriRadius.sm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    'VIEW ALL',
                    style: context.typography.labelCaps.copyWith(
                      color: KaloriColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: KaloriSpacing.md),

          // Log Items
          ...logs.asMap().entries.map((entry) {
            final int index = entry.key;
            final FoodLogItem item = entry.value;
            final bool isLast = index == logs.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : KaloriSpacing.sm),
              child: _buildLogCard(context, item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, FoodLogItem item) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 12.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(KaloriSpacing.md),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              borderRadius: BorderRadius.circular(KaloriRadius.md),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 24),
          ),
          const SizedBox(width: KaloriSpacing.sm),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.typography.bodyLg.copyWith(
                    fontWeight: FontWeight.w600,
                    color: KaloriColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

          // Calories
          Text(
            item.calories,
            style: context.typography.bodyLg.copyWith(
              fontWeight: FontWeight.w700,
              color: KaloriColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
