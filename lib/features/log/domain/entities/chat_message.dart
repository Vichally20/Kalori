/// Entity representing a chat bubble message inside the Log Screen.
class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });

  ChatMessage copyWith({
    String? text,
    bool? isUser,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
    );
  }
}
