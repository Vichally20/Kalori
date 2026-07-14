import 'package:get/get.dart';
import '../../../../features/profile/view/bindings/profile_binding.dart';
import '../../../../features/profile/view/screens/profile_screen.dart';

class ProfileRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: ProfileView.path,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
