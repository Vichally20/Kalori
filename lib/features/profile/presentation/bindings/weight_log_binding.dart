import 'package:get/get.dart';
import 'package:kalori/features/profile/presentation/controllers/weight_log_controller.dart';

class WeightLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeightLogController>(() => WeightLogController());
  }
}
