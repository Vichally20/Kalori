import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:isar/isar.dart';
import 'package:kalori/core/services/isar_service.dart';
import 'package:kalori/features/log/data/models/food_item_model.dart';
import 'package:kalori/features/log/data/models/meal_log_entry_model.dart';
import 'package:kalori/features/log/data/models/isar/isar_food_item.dart';

/// Local data source interface for meal logs storage
abstract class LogLocalDataSource {
  Future<List<MealLogEntryModel>> getSavedMealItems();
  Stream<List<MealLogEntryModel>> watchMealItems();
  Future<List<FoodItemModel>> getFrequentMeals({int limit = 3});
  Future<void> saveMealItem(MealLogEntryModel item);
  Future<void> deleteMealItem(String uuid);
}

class LogLocalDataSourceImpl implements LogLocalDataSource {
  final isar = Get.find<IsarService>().isar;
  
  @override
  Future<List<MealLogEntryModel>> getSavedMealItems() async {
    final isarItems = await isar.isarFoodItems
        .where()
        .sortByCreatedAtDesc()
        .findAll();
    return isarItems.map((isarItem) {
      final entity = isarItem.toMealLogEntry();
      return MealLogEntryModel.fromEntity(entity);
    }).toList();
  }

  @override
  Stream<List<MealLogEntryModel>> watchMealItems() {
    return isar.isarFoodItems
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((isarItems) {
      return isarItems.map((isarItem) {
        final entity = isarItem.toMealLogEntry();
        return MealLogEntryModel.fromEntity(entity);
      }).toList();
    });
  }

  @override
  Future<List<FoodItemModel>> getFrequentMeals({int limit = 3}) async {
    final allItems = await isar.isarFoodItems.where().findAll();
    
    // Calculate frequencies
    final frequencyMap = <String, int>{};
    final itemsMap = <String, IsarFoodItem>{};
    
    for (var item in allItems) {
      if (item.title == null || item.title!.isEmpty) continue;
      final title = item.title!.toLowerCase();
      frequencyMap[title] = (frequencyMap[title] ?? 0) + 1;
      itemsMap[title] = item;
    }
    
    // Sort by frequency descending
    final sortedTitles = frequencyMap.keys.toList()
      ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));
      
    // Take top N
    final topTitles = sortedTitles.take(limit);
    
    return topTitles.map((t) {
      final entry = itemsMap[t]!.toMealLogEntry();
      return FoodItemModel.fromEntity(entry.foodItem!);
    }).toList();
  }

  @override
  Future<void> saveMealItem(MealLogEntryModel item) async {
    final isarFood = IsarFoodItem.fromMealLogEntry(item);
    await isar.writeTxn(() async {
      await isar.isarFoodItems.put(isarFood);
    });
  }

  @override
  Future<void> deleteMealItem(String uuid) async {
    await isar.writeTxn(() async {
      await isar.isarFoodItems.filter().uuidEqualTo(uuid).deleteAll();
    });
  }
}
