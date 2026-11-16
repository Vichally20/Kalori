import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';

/// Single-field dialog that returns the entered text on Save (null on Cancel).
///
/// Owns its [TextEditingController] so it is disposed only after the dialog's
/// closing animation, never while the field is still on screen.
class ValueInputDialog extends StatefulWidget {
  final String title;
  final String initialText;
  final String? suffix;
  final TextInputType keyboardType;
  final String? Function(String) validator;

  const ValueInputDialog({
    super.key,
    required this.title,
    required this.initialText,
    required this.keyboardType,
    required this.validator,
    this.suffix,
  });

  /// Weight dialog in kg (30–250), returning the parsed value or null.
  static Future<double?> weight({required String title, required double initialKg}) async {
    final text = await Get.dialog<String>(
      ValueInputDialog(
        title: title,
        initialText: formatKg(initialKg),
        suffix: 'kg',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) {
          final kg = _parse(v);
          if (kg == null || kg < 30 || kg > 250) {
            return 'Enter a weight between 30 and 250 kg';
          }
          return null;
        },
      ),
    );
    return text == null ? null : _parse(text);
  }

  /// `76.8` / `77` (no trailing .0).
  static String formatKg(double v) {
    final r = (v * 10).round() / 10;
    return r == r.roundToDouble() ? r.round().toString() : r.toStringAsFixed(1);
  }

  static double? _parse(String v) => double.tryParse(v.trim().replaceAll(',', '.'));

  @override
  State<ValueInputDialog> createState() => _ValueInputDialogState();
}

class _ValueInputDialogState extends State<ValueInputDialog> {
  late final TextEditingController _field = TextEditingController(text: widget.initialText);
  String? _error;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _submit() {
    final error = widget.validator(_field.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Get.back<String>(result: _field.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KaloriColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: KaloriRadius.borderLg),
      title: Text(widget.title),
      content: TextField(
        controller: _field,
        autofocus: true,
        keyboardType: widget.keyboardType,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(suffixText: widget.suffix, errorText: _error),
      ),
      actions: [
        TextButton(onPressed: () => Get.back<String>(), child: const Text('Cancel')),
        TextButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
