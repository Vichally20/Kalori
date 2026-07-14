import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/model/notification_item.dart';

/// Empty state widget shown when there are no notifications matching the current filter.
class NotificationsEmptyState extends StatelessWidget {
  final NotificationFilter filter;

  const NotificationsEmptyState({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData icon;

    switch (filter) {
      case NotificationFilter.unread:
        title = "You're All Caught Up!";
        subtitle = "You have read all your notifications. Check back later for new insights & reminders.";
        icon = Icons.mark_email_read_outlined;
        break;
      case NotificationFilter.reminders:
        title = "No Reminders Right Now";
        subtitle = "When you set meal alerts or water reminders, they'll show up right here.";
        icon = Icons.alarm_off_rounded;
        break;
      case NotificationFilter.insights:
        title = "No Nutrition Insights Yet";
        subtitle = "Keep logging your daily meals! Our AI will analyze your trends and deliver personalized tips.";
        icon = Icons.insights_rounded;
        break;
      case NotificationFilter.achievements:
        title = "No Achievements Yet";
        subtitle = "Hit your protein targets and maintain daily logging streaks to unlock rewards here.";
        icon = Icons.emoji_events_outlined;
        break;
      case NotificationFilter.all:
        title = "No Notifications";
        subtitle = "Your notifications box is completely empty right now. Keep logging to earn rewards!";
        icon = Icons.notifications_none_rounded;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: KaloriColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40.0,
                color: KaloriColors.primary,
              ),
            ),
            const SizedBox(height: KaloriSpacing.lg),
            Text(
              title,
              style: context.typography.headlineMd.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KaloriSpacing.sm),
            Text(
              subtitle,
              style: context.typography.bodySm.copyWith(
                fontSize: 14.0,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
