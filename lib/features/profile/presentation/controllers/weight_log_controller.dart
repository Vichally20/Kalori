import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/services/user_profile_service.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/presentation/widgets/value_input_dialog.dart';
import 'package:kalori/shared/shared.dart';

/// Weight log: every weigh-in in chronological order, plus logging today's weight.
class WeightLogController extends GetxController {
  final UserProfileService profiles = Get.find<UserProfileService>();

  UserProfile? get profile => profiles.profile.value;

  /// Oldest first (the service keeps the log sorted).
  List<WeightEntry> get entries => profile?.weightLog ?? const <WeightEntry>[];

  WeightEntry? get todayEntry {
    final today = DateTime.now().dateOnly;
    for (final e in entries) {
      if (e.date.dateOnly == today) {
        return e;
      }
    }
    return null;
  }

  Future<void> logToday() async {
    final existing = todayEntry;
    final kg = await ValueInputDialog.weight(
      title: existing == null ? "Today's weight" : "Update today's weight",
      initialKg: existing?.kg ?? profile?.weightKg ?? 70,
    );
    if (kg == null) {
      return;
    }
    await profiles.logWeight(kg);
    KaloriToast.showSuccess(title: 'Weight logged', message: '${ValueInputDialog.formatKg(kg)} kg saved for today.');
  }

  /// Pick any past day (up to today), then enter that day's weight.
  /// A day that already has an entry is updated rather than duplicated.
  Future<void> addForAnotherDay() async {
    final context = Get.context;
    if (context == null) {
      return;
    }
    final today = DateTime.now().dateOnly;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year, today.month, today.day - 1),
      firstDate: DateTime(today.year - 5),
      lastDate: today,
      helpText: 'WHICH DAY DID YOU WEIGH IN?',
      confirmText: 'Next',
    );
    if (picked == null) {
      return;
    }
    final day = picked.dateOnly;
    WeightEntry? existing;
    WeightEntry? nearest; // latest entry on or before the picked day, for a sensible default
    for (final e in entries) {
      final d = e.date.dateOnly;
      if (d == day) {
        existing = e;
      }
      if (!d.isAfter(day)) {
        nearest = e;
      }
    }
    nearest ??= entries.isEmpty ? null : entries.first;
    final label = HistoryFormat.shortDate(day);
    final kg = await ValueInputDialog.weight(
      title: existing == null ? 'Weight on $label' : 'Update weight on $label',
      initialKg: existing?.kg ?? nearest?.kg ?? profile?.weightKg ?? 70,
    );
    if (kg == null) {
      return;
    }
    await profiles.setWeightFor(day, kg);
    KaloriToast.showSuccess(
      title: existing == null ? 'Weigh-in added' : 'Weigh-in updated',
      message: '${ValueInputDialog.formatKg(kg)} kg on $label.',
    );
  }

  Future<void> editEntry(WeightEntry entry) async {
    final kg = await ValueInputDialog.weight(
      title: 'Weight on ${HistoryFormat.shortDate(entry.date)}',
      initialKg: entry.kg,
    );
    if (kg != null) {
      await profiles.setWeightFor(entry.date, kg);
    }
  }

  /// Deletes [entry] and offers Undo.
  Future<void> deleteEntry(WeightEntry entry) async {
    await profiles.deleteWeightFor(entry.date);
    KaloriToast.show(
      title: 'Entry deleted',
      message: '${ValueInputDialog.formatKg(entry.kg)} kg on ${HistoryFormat.shortDate(entry.date)}',
      actionLabel: 'Undo',
      onAction: () => profiles.setWeightFor(entry.date, entry.kg),
    );
  }
}
