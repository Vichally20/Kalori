import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:isar/isar.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';
import '../models/food_item_model.dart';

/// Local data source interface for meal logs storage
abstract class LogLocalDataSource {
  Future<List<FoodItemModel>> getSavedMealItems();
  Future<List<FoodItemModel>> getFrequentMeals({int limit = 3});
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
  Future<List<FoodItemModel>> getFrequentMeals({int limit = 3}) async {
    final allItems = await isar.isarFoodItems.where().findAll();
    
    // Calculate frequencies
    final frequencyMap = <String, int>{};
    final itemsMap = <String, IsarFoodItem>{};
    
    for (var item in allItems) {
      final title = item.title?.toLowerCase() ?? '';
      frequencyMap[title] = (frequencyMap[title] ?? 0) + 1;
      itemsMap[title] = item;
    }
    
    // Sort by frequency descending
    final sortedTitles = frequencyMap.keys.toList()
      ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));
      
    // Take top N
    final topTitles = sortedTitles.take(limit);
    
    return topTitles.map((t) {
      final entity = itemsMap[t]!.toEntity();
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
