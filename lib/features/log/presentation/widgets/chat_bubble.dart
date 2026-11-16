import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/log/domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 48.0, bottom: KaloriSpacing.md),
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14.0,
          ),
          decoration: BoxDecoration(
            color: KaloriColors.successGreen,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          child: Text(
            message.text,
            style: context.typography.bodyLg.copyWith(
              color: KaloriColors.onSuccessGreen,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(right: 48.0, bottom: KaloriSpacing.md),
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 14.0,
          ),
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              topLeft: Radius.circular(4.0),
            ),
            border: Border.all(color: KaloriColors.borderSlate),
            boxShadow: [
              BoxShadow(
                color: KaloriColors.cardShadow,
                blurRadius: 10.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: context.typography.bodyLg.copyWith(
              color: KaloriColors.onSurface,
              height: 1.4,
            ),
          ),
        ),
      );
    }
  }
}
