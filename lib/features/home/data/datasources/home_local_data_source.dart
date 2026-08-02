import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:isar/isar.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';

import '../../../log/data/models/food_item_model.dart';

/// Data source interface for home local storage
abstract class HomeLocalDataSource {
  Future<List<FoodItemModel>> getRecentLogs();
}

/// Implementation of [HomeLocalDataSource]
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final isar = Get.find<IsarService>().isar;
  @override
  Future<List<FoodItemModel>> getRecentLogs() async {
    final isarItems = await isar.isarFoodItems
    .where()
    .sortByCreatedAtDesc()
    .limit(3)
    .findAll();
    return isarItems.map((isarItem) {
      return FoodItemModel.fromEntity(isarItem.toEntity());
    }).toList();
  }
}
