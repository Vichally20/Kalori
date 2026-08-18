import 'package:get/get.dart';
import 'package:kalori/features/history/presentation/bindings/history_binding.dart';
import 'package:kalori/features/history/presentation/screens/history_screen.dart';

class HistoryRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: HistoryView.path,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
