import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kalori/core/bindings/initial_binding.dart';
import 'package:kalori/core/routes/app_pages.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/ai_service.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Get.putAsync(() => IsarService().init());
  await Get.putAsync(() => AIService().init());
  final profiles = await Get.putAsync(() => UserProfileService().init(), permanent: true);
  runApp(KaloriApp(initialRoute: profiles.hasProfile ? AppRoutes.home : AppRoutes.onboarding));
}

class KaloriApp extends StatelessWidget {
  /// Onboarding until a profile has been saved, then Home.
  final String initialRoute;

  const KaloriApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kalori',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      theme: KaloriTheme.light,
    );
  }
}