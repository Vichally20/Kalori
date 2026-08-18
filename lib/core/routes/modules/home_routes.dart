import 'package:get/get.dart';
import 'package:kalori/features/home/presentation/bindings/home_binding.dart';
import 'package:kalori/features/home/presentation/screens/home_screen.dart';

class HomeRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: HomeView.path,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
