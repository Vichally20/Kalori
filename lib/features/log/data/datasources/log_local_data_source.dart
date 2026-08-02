import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:isar/isar.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';
import '../models/food_item_model.dart';

/// Local data source interface for meal logs storage
abstract class LogLocalDataSource {
  Future<List<FoodItemModel>> getSavedMealItems();
  Future<void> saveMealItem(FoodItemModel item);
}

class LogLocalDataSourceImpl implements LogLocalDataSource {
  final isar = Get.find<IsarService>().isar;
  @override
  Future<List<FoodItemModel>> getSavedMealItems() async {
    final isarItems = await isar.isarFoodItems
        .where()
        .sortByCreatedAtDesc()
        .findAll();
    return isarItems.map((isarItem) {
      final entity = isarItem.toEntity();
      return FoodItemModel.fromEntity(entity);
    }).toList();
  }

  @override
  Future<void> saveMealItem(FoodItemModel item) async {
    //firstly convert the foodItem to an isar foodItem
    final isarFood = IsarFoodItem.fromEntity(item);
    await isar.writeTxn(() async {
      await isar.isarFoodItems.put(isarFood);
    });
  }
}
