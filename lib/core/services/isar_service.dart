import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';
import 'package:path_provider/path_provider.dart';

class IsarService extends GetxService{
  late final Isar isar;

  Future<IsarService> init() async {
    if (Isar.instanceNames.isEmpty) {
      final dbPath = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [IsarFoodItemSchema],
        directory: dbPath.path,
        inspector: true,
      );
    }else {
      isar = Isar.getInstance()!;
    }
    return this;
  }
}
