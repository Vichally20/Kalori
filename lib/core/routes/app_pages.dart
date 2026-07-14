import 'package:get/get.dart';
import 'modules/history_routes.dart';
import 'modules/home_routes.dart';
import 'modules/log_routes.dart';
import 'modules/notifications_routes.dart';
import 'modules/profile_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    ...HomeRoutes.routes,
    ...ProfileRoutes.routes,
    ...LogRoutes.routes,
    ...NotificationsRoutes.routes,
    ...HistoryRoutes.routes,
  ];
}
