import 'package:get/get.dart';
import '../../../../features/history/presentation/bindings/history_binding.dart';
import '../../../../features/history/presentation/screens/history_screen.dart';

class HistoryRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: HistoryView.path,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
  ];
}
