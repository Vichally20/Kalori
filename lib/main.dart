import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/bindings/initial_binding.dart';
import 'package:kalori/core/routes/app_pages.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/core/services/ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Get.putAsync(() => IsarService().init());
  await Get.putAsync(() => AIService().init());
  runApp(const KaloriApp());
}

class KaloriApp extends StatelessWidget {
  const KaloriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kalori',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      theme: KaloriTheme.light,
    );
  }
}