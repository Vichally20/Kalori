import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/bindings/initial_binding.dart';
import 'package:kalori/core/routes/app_pages.dart';
import 'package:kalori/core/routes/app_routes.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => IsarService().init());
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