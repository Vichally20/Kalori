import 'package:kalori/features/history/presentation/screens/history_day_screen.dart';
import 'package:kalori/features/history/presentation/screens/history_screen.dart';
import 'package:kalori/features/home/presentation/screens/home_screen.dart';
import 'package:kalori/features/log/presentation/screens/log_screen.dart';
import 'package:kalori/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:kalori/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kalori/features/profile/presentation/screens/profile_screen.dart';
import 'package:kalori/features/profile/presentation/screens/weight_log_screen.dart';
import 'package:kalori/features/water/presentation/screens/water_screen.dart';

abstract class AppRoutes {
  static String home = HomeView.path;
  static String profile = ProfileView.path;
  static String log = LogView.path;
  static String history = HistoryView.path;
  static String historyDay = HistoryDayView.path;
  static String notifications = NotificationsView.path;
  static String onboarding = OnboardingView.path;
  static String weightLog = WeightLogView.path;
  static String water = WaterView.path;

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
