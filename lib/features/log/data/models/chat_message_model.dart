import '../../domain/entities/chat_message.dart';

/// Data model extending [ChatMessage] with serialization logic.
class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.text,
    required super.isUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      text: map['text'] as String? ?? '',
      isUser: map['isUser'] as bool? ?? false,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      text: entity.text,
      isUser: entity.isUser,
    );
  }
}
