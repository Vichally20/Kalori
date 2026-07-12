import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SuggestionChipsRow extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onChipTap;

  const SuggestionChipsRow({
    super.key,
    required this.suggestions,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: suggestions.map((text) {
        return GestureDetector(
          onTap: () => onChipTap(text),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(KaloriRadius.full),
              border: Border.all(color: KaloriColors.borderSlate),
            ),
            child: Text(
              text,
              style: context.typography.labelCaps.copyWith(
                color: const Color(0xFF0D1C2F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
