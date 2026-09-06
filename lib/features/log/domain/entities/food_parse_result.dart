import 'package:equatable/equatable.dart';
import 'package:kalori/features/log/domain/entities/food_item.dart';

/// Represents the result of parsing food input with the AI service.
class FoodParseResult extends Equatable {
  final bool needsClarification;
  final String? replyMessage;
  final FoodItem? foodItem;

  const FoodParseResult({
    required this.needsClarification,
    this.replyMessage,
    this.foodItem,
  });

  @override
  List<Object?> get props => [needsClarification, replyMessage, foodItem];
}
