import 'package:get/get.dart';
import 'package:kalori/core/routes/modules/history_routes.dart';
import 'package:kalori/core/routes/modules/home_routes.dart';
import 'package:kalori/core/routes/modules/log_routes.dart';
import 'package:kalori/core/routes/modules/notifications_routes.dart';
import 'package:kalori/core/routes/modules/profile_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    ...HomeRoutes.routes,
    ...ProfileRoutes.routes,
    ...LogRoutes.routes,
    ...NotificationsRoutes.routes,
    ...HistoryRoutes.routes,
  ];
}
