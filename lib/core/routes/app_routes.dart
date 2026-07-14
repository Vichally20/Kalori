import '../../features/history/view/screens/history_screen.dart';
import '../../features/home/view/screens/home_screen.dart';
import '../../features/log/view/screens/log_screen.dart';
import '../../features/notifications/view/screens/notifications_screen.dart';
import '../../features/profile/view/screens/profile_screen.dart';

abstract class AppRoutes {
  static String home = HomeView.path;
  static String profile = ProfileView.path;
  static String log = LogView.path;
  static String history = HistoryView.path;
  static String notifications = NotificationsView.path;

  static const String settings = '/settings';
  static const String helpAndFeedback = '/helpAndFeedback';
  static const String account = '/account';
  static const String subscriptions = '/subscriptions';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsOfService = '/termsOfService';
  static const String integrations = '/integrations';
  static const String insights = '/insights';
  static const String waterTracker = '/waterTracker';
  static const String foodLibrary = '/foodLibrary';
}
