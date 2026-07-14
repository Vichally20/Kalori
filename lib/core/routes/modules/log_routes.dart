import 'package:get/get.dart';
import '../../../../features/log/view/bindings/log_binding.dart';
import '../../../../features/log/view/screens/log_screen.dart';

class LogRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: LogView.path,
      page: () => const LogView(),
      binding: LogBinding(),
    ),
  ];
}
