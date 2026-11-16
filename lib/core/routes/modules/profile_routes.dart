import 'package:get/get.dart';
import 'package:kalori/features/profile/presentation/bindings/profile_binding.dart';
import 'package:kalori/features/profile/presentation/bindings/weight_log_binding.dart';
import 'package:kalori/features/profile/presentation/screens/profile_screen.dart';
import 'package:kalori/features/profile/presentation/screens/weight_log_screen.dart';

class ProfileRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: ProfileView.path,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: WeightLogView.path,
      page: () => const WeightLogView(),
      binding: WeightLogBinding(),
    ),
  ];
}
