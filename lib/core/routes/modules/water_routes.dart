import 'package:get/get.dart';
import 'package:kalori/features/water/presentation/screens/water_screen.dart';

class WaterRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(name: WaterView.path, page: () => const WaterView()),
  ];
}
