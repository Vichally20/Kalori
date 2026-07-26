import 'package:get/get.dart';
import '../../../../features/log/presentation/bindings/log_binding.dart';
import '../../../../features/log/presentation/screens/log_screen.dart';

class LogRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: LogView.path,
      page: () => const LogView(),
      binding: LogBinding(),
    ),
  ];
}
