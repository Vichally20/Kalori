import 'package:get/get.dart';
import '../../../../features/home/view/bindings/home_binding.dart';
import '../../../../features/home/view/screens/home_screen.dart';

class HomeRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: HomeView.path,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
