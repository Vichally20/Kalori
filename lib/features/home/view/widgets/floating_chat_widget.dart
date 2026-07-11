import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class FloatingChatWidget extends StatelessWidget {
  final HomeController controller;

  const FloatingChatWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0D1C2F),
            blurRadius: 24.0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
      child: Row(
        children: [
          // Microphone Icon
          const Icon(
            Icons.mic_none,
            color: KaloriColors.outline,
            size: 24.0,
          ),
          const SizedBox(width: 4.0),

          // Text Input Field
          Expanded(
            child: TextField(
              controller: controller.chatController,
              decoration: InputDecoration(
                hintText: 'What did you eat?',
                hintStyle: context.typography.bodyLg.copyWith(
                  color: KaloriColors.outline,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
              ),
              style: context.typography.bodyLg.copyWith(
                color: KaloriColors.onSurface,
              ),
              onSubmitted: (_) => controller.submitChatLog(),
            ),
          ),

          // Send Button (Green Pill/Rounded Square)
          GestureDetector(
            onTap: controller.submitChatLog,
            child: Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: KaloriColors.successGreen,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
