import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/model/model.dart';

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
          decoration: const BoxDecoration(
            color: KaloriColors.successGreen,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(18.0),
              topRight: Radius.circular(4.0),
            ),
          ),
          child: Text(
            message.text,
            style: context.typography.bodyLg.copyWith(
              color: const Color(0xFF0D1C2F),
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
            border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0D1C2F),
                blurRadius: 10.0,
                offset: Offset(0, 2),
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
