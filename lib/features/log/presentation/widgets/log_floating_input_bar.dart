import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/log_controller.dart';

class LogFloatingInputBar extends StatelessWidget {
  final LogController controller;

  const LogFloatingInputBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.full),
        border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D1C2F),
            blurRadius: 20.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Row(
        children: [
          // Plus Icon
          const Icon(
            Icons.add_circle_outline,
            color: Color(0xFF0D1C2F),
            size: 26.0,
          ),
          const SizedBox(width: 10.0),

          // Text Field
          Expanded(
            child: TextField(
              controller: controller.inputController,
              decoration: InputDecoration(
                hintText: 'What else did you eat?',
                hintStyle: context.typography.bodyLg.copyWith(
                  color: KaloriColors.outline,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
              ),
              style: context.typography.bodyLg.copyWith(
                color: KaloriColors.onSurface,
              ),
              onSubmitted: (_) => controller.submitInput(),
            ),
          ),
          const SizedBox(width: 8.0),

          // Green Send Button (Square with curved edge)
          GestureDetector(
            onTap: controller.submitInput,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: const Color(0xFF006C49),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: const Icon(
                Icons.arrow_upward,
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
