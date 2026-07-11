import 'package:get/get.dart';
import '../../features/home/view/bindings/home_binding.dart';
import '../../features/home/view/screens/home_screen.dart';
import '../../features/log/view/bindings/log_binding.dart';
import '../../features/log/view/screens/log_screen.dart';
import '../../features/profile/view/bindings/profile_binding.dart';
import '../../features/profile/view/screens/profile_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.log,
      page: () => const LogView(),
      binding: LogBinding(),
    ),
  ];
}

