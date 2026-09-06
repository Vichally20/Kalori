import 'package:kalori/features/log/data/models/food_item_model.dart';
import 'package:kalori/features/log/domain/entities/food_parse_result.dart';

/// Data model extending [FoodParseResult] with serialization logic.
class FoodParseResultModel extends FoodParseResult {
  const FoodParseResultModel({
    required super.needsClarification,
    super.replyMessage,
    super.foodItem,
  });

  factory FoodParseResultModel.fromMap(Map<String, dynamic> map) {
    return FoodParseResultModel(
      needsClarification: map['needs_clarification'] as bool? ?? false,
      replyMessage: map['reply_message'] as String?,
      foodItem: map['meal_data'] != null ? FoodItemModel.fromMap(map['meal_data'] as Map<String, dynamic>) : null,
    );
  }
}
