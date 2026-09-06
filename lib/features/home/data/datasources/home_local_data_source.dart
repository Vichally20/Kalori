import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:isar/isar.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/features/log/data/models/food_item_model.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';

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
    .findAll();
    
    return isarItems
        .map((isarItem) => isarItem.toMealLogEntry().foodItem)
        .whereType<FoodItem>()
        .take(3)
        .map((entity) => FoodItemModel.fromEntity(entity))
        .toList();
  }
}
