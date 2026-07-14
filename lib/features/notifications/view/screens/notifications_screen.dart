import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_filter_bar.dart';

/// Main screen view for Notifications in Kalori.
class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      appBar: AppBar(
        backgroundColor: KaloriColors.surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: context.typography.headlineMd.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Obx(() {
            final hasUnread = controller.unreadCount > 0;
            if (!hasUnread) return const SizedBox.shrink();

            return TextButton.icon(
              onPressed: () => controller.markAllAsRead(),
              icon: const Icon(
                Icons.done_all_rounded,
                size: 18.0,
                color: KaloriColors.primary,
              ),
              label: Text(
                'Mark read',
                style: TextStyle(
                  fontFamily: KaloriTypography.fontFamily,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: KaloriColors.primary,
                ),
              ),
            );
          }),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: KaloriColors.onSurfaceVariant),
            onSelected: (value) {
              if (value == 'clear_all') {
                _showClearConfirmation(context);
              } else if (value == 'mark_all') {
                controller.markAllAsRead();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 20.0, color: KaloriColors.onSurface),
                    SizedBox(width: 12.0),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_outlined, size: 20.0, color: KaloriColors.error),
                    SizedBox(width: 12.0),
                    Text('Clear all notifications', style: TextStyle(color: KaloriColors.error)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4.0),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: KaloriSpacing.sm),
          // Filter Bar
          Obx(() => NotificationsFilterBar(
                selectedFilter: controller.selectedFilter,
                onFilterChanged: controller.setFilter,
                unreadCount: controller.unreadCount,
              )),
          const SizedBox(height: KaloriSpacing.md),

          // Notification Cards List
          Expanded(
            child: Obx(() {
              final items = controller.filteredNotifications;

              if (items.isEmpty) {
                return NotificationsEmptyState(
                  filter: controller.selectedFilter.value,
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: KaloriSpacing.containerMargin,
                  right: KaloriSpacing.containerMargin,
                  bottom: KaloriSpacing.xl,
                ),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: KaloriSpacing.sm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return NotificationCard(
                    item: item,
                    onDismiss: () => controller.deleteNotification(item.id),
                    onToggleRead: () => controller.toggleReadStatus(item.id),
                    onActionClick: () => controller.handleActionClick(item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: KaloriColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderLg),
        title: Text(
          'Clear all notifications?',
          style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'This will permanently remove your notification history and alerts from the list.',
          style: context.typography.bodySm,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: KaloriColors.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KaloriColors.error,
              foregroundColor: KaloriColors.onError,
              shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderDefault),
            ),
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            child: const Text('Clear All', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
