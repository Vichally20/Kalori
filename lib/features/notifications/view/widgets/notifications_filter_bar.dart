import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/model/notification_item.dart';

/// Horizontal scrollable bar with filter pills for the notifications list.
class NotificationsFilterBar extends StatelessWidget {
  final Rx<NotificationFilter> selectedFilter;
  final ValueChanged<NotificationFilter> onFilterChanged;
  final int unreadCount;

  const NotificationsFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.containerMargin),
      child: Row(
        children: [
          _buildPill(
            label: 'All',
            filter: NotificationFilter.all,
            badgeCount: null,
          ),
          const SizedBox(width: 8.0),
          _buildPill(
            label: 'Unread',
            filter: NotificationFilter.unread,
            badgeCount: unreadCount > 0 ? unreadCount : null,
          ),
          const SizedBox(width: 8.0),
          _buildPill(
            label: 'Reminders',
            filter: NotificationFilter.reminders,
            badgeCount: null,
          ),
          const SizedBox(width: 8.0),
          _buildPill(
            label: 'Insights',
            filter: NotificationFilter.insights,
            badgeCount: null,
          ),
          const SizedBox(width: 8.0),
          _buildPill(
            label: 'Achievements',
            filter: NotificationFilter.achievements,
            badgeCount: null,
          ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required String label,
    required NotificationFilter filter,
    int? badgeCount,
  }) {
    return Obx(() {
      final bool isSelected = selectedFilter.value == filter;

      return GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? KaloriColors.primary : KaloriColors.surfaceContainerHigh,
            borderRadius: KaloriRadius.borderFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: KaloriTypography.fontFamily,
                  fontSize: 13.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? KaloriColors.onPrimary : KaloriColors.onSurfaceVariant,
                ),
              ),
              if (badgeCount != null) ...[
                const SizedBox(width: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: isSelected ? KaloriColors.onPrimary : KaloriColors.primary,
                    borderRadius: KaloriRadius.borderFull,
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: TextStyle(
                      fontFamily: KaloriTypography.fontFamily,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? KaloriColors.primary : KaloriColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
