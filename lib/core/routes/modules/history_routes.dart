import 'package:get/get.dart';
import '../../../../features/history/view/bindings/history_binding.dart';
import '../../../../features/history/view/screens/history_screen.dart';

class HistoryRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: HistoryView.path,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
