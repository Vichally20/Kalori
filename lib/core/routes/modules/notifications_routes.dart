import 'package:get/get.dart';
import '../../../../features/notifications/presentation/bindings/notifications_binding.dart';
import '../../../../features/notifications/presentation/screens/notifications_screen.dart';

class NotificationsRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: NotificationsView.path,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}
