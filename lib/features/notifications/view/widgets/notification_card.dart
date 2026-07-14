import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/model/notification_item.dart';

/// Interactive card displaying a single notification with swipe-to-dismiss and action support.
class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onDismiss;
  final VoidCallback onToggleRead;
  final VoidCallback? onActionClick;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onDismiss,
    required this.onToggleRead,
    this.onActionClick,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: KaloriSpacing.lg),
        decoration: BoxDecoration(
          color: KaloriColors.errorContainer,
          borderRadius: KaloriRadius.borderLg,
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: KaloriColors.onErrorContainer,
          size: 28.0,
        ),
      ),
      child: Obx(() {
        final bool isRead = item.isRead.value;

        return GestureDetector(
          onTap: onToggleRead,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(KaloriSpacing.md),
            decoration: BoxDecoration(
              color: isRead
                  ? KaloriColors.surfaceContainerLowest
                  : KaloriColors.surfaceContainerLow,
              borderRadius: KaloriRadius.borderLg,
              border: Border.all(
                color: isRead
                    ? KaloriColors.outlineVariant.withValues(alpha: 0.3)
                    : KaloriColors.primary.withValues(alpha: 0.4),
                width: isRead ? 1.0 : 1.5,
              ),
              boxShadow: isRead
                  ? []
                  : [
                      BoxShadow(
                        color: KaloriColors.primary.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon Badge
                _buildCategoryBadge(item.category),
                const SizedBox(width: KaloriSpacing.sm),

                // Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Title + Timestamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: context.typography.headlineMd.copyWith(
                                fontSize: 16.0,
                                fontWeight: isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: isRead
                                    ? KaloriColors.onSurface.withValues(alpha: 0.8)
                                    : KaloriColors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            item.timestamp,
                            style: context.typography.bodySm.copyWith(
                              fontSize: 12.0,
                              color: isRead
                                  ? KaloriColors.outline
                                  : KaloriColors.primary,
                              fontWeight: isRead
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),

                      // Message text
                      Text(
                        item.message,
                        style: context.typography.bodySm.copyWith(
                          fontSize: 14.0,
                          color: isRead
                              ? KaloriColors.onSurfaceVariant.withValues(alpha: 0.9)
                              : KaloriColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),

                      // Optional Action Button
                      if (item.actionLabel != null &&
                          item.actionLabel!.isNotEmpty) ...[
                        const SizedBox(height: KaloriSpacing.sm),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: onActionClick,
                            borderRadius: KaloriRadius.borderDefault,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: isRead
                                    ? KaloriColors.surfaceContainerHighest
                                    : KaloriColors.primary,
                                borderRadius: KaloriRadius.borderDefault,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.actionLabel!,
                                    style: TextStyle(
                                      fontFamily: KaloriTypography.fontFamily,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: isRead
                                          ? KaloriColors.onSurfaceVariant
                                          : KaloriColors.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.0,
                                    color: isRead
                                        ? KaloriColors.onSurfaceVariant
                                        : KaloriColors.onPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Unread Dot indicator
                if (!isRead) ...[
                  const SizedBox(width: 8.0),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: KaloriColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryBadge(NotificationCategory category) {
    Color bg;
    Color iconColor;
    IconData icon;

    switch (category) {
      case NotificationCategory.reminder:
        bg = KaloriColors.primaryContainer;
        iconColor = KaloriColors.onPrimaryContainer;
        icon = Icons.alarm_rounded;
        break;
      case NotificationCategory.achievement:
        bg = KaloriColors.secondaryContainer;
        iconColor = KaloriColors.onSecondaryContainer;
        icon = Icons.emoji_events_rounded;
        break;
      case NotificationCategory.insight:
        bg = KaloriColors.tertiaryContainer;
        iconColor = KaloriColors.onTertiaryContainer;
        icon = Icons.lightbulb_outline_rounded;
        break;
      case NotificationCategory.system:
        bg = KaloriColors.surfaceContainerHighest;
        iconColor = KaloriColors.onSurfaceVariant;
        icon = Icons.info_outline_rounded;
        break;
      case NotificationCategory.social:
        bg = const Color(0xFFE8DEFF);
        iconColor = const Color(0xFF381E72);
        icon = Icons.people_outline_rounded;
        break;
    }

    return Container(
      width: 42.0,
      height: 42.0,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: KaloriRadius.borderMd,
      ),
      child: Icon(icon, color: iconColor, size: 22.0),
    );
  }
}
