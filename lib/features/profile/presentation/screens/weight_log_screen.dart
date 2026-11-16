import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/domain/entities/day_summary.dart';
import 'package:kalori/features/history/presentation/utils/history_format.dart';
import 'package:kalori/features/profile/domain/entities/user_profile.dart';
import 'package:kalori/features/profile/presentation/controllers/weight_log_controller.dart';
import 'package:kalori/features/profile/presentation/widgets/value_input_dialog.dart';
import 'package:kalori/features/profile/presentation/widgets/weight_sparkline.dart';

/// Every logged weight with its date, oldest first, and a pinned "Log today's weight" button.
///
/// Opens scrolled to the bottom so the newest entries sit next to the button.
class WeightLogView extends StatefulWidget {
  static String path = '/profile/weight';

  const WeightLogView({super.key});

  @override
  State<WeightLogView> createState() => _WeightLogViewState();
}

class _WeightLogViewState extends State<WeightLogView> {
  final WeightLogController controller = Get.find<WeightLogController>();
  final ScrollController _scroll = ScrollController();
  int _lastCount = -1;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Jump to the newest entry on first build, and animate there when an entry is added.
  void _followNewest(int count) {
    final grew = count > _lastCount;
    final first = _lastCount < 0;
    _lastCount = count;
    if (!grew) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) {
        return;
      }
      final end = _scroll.position.maxScrollExtent;
      if (first) {
        _scroll.jumpTo(end);
      } else {
        _scroll.animateTo(end, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      appBar: AppBar(
        backgroundColor: KaloriColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
          onPressed: () => Get.back<void>(),
        ),
        title: Text('Weight log', style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700)),
      ),
      body: Obx(() {
        final profile = controller.profile;
        final entries = controller.entries;
        _followNewest(entries.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: entries.isEmpty || profile == null
                  ? const _EmptyLog()
                  : ListView(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(
                        KaloriSpacing.containerMargin,
                        KaloriSpacing.xs,
                        KaloriSpacing.containerMargin,
                        KaloriSpacing.md,
                      ),
                      children: [
                        _Summary(profile: profile, entries: entries),
                        const SizedBox(height: KaloriSpacing.lg),
                        ..._entryList(context, profile, entries),
                        const SizedBox(height: KaloriSpacing.xs),
                        Text(
                          'Tap an entry to change it. Swipe left to delete.',
                          textAlign: TextAlign.center,
                          style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
                        ),
                      ],
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  KaloriSpacing.containerMargin,
                  KaloriSpacing.xs,
                  KaloriSpacing.containerMargin,
                  KaloriSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton.icon(
                      onPressed: controller.addForAnotherDay,
                      style: TextButton.styleFrom(
                        foregroundColor: KaloriColors.primary,
                        minimumSize: const Size.fromHeight(44.0),
                      ),
                      icon: const Icon(Icons.edit_calendar_outlined, size: 20.0),
                      label: const Text('Add a weigh-in for another day'),
                    ),
                    const SizedBox(height: 4.0),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52.0)),
                      onPressed: controller.logToday,
                      icon: Icon(controller.todayEntry == null ? Icons.add_rounded : Icons.edit_outlined),
                      label: Text(controller.todayEntry == null ? "Log today's weight" : "Update today's weight"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Rows grouped under month headers, oldest first.
  List<Widget> _entryList(BuildContext context, UserProfile profile, List<WeightEntry> entries) {
    final today = DateTime.now().dateOnly;
    final widgets = <Widget>[];
    int? month;
    int? year;
    var groupRows = <Widget>[];

    void flush() {
      if (groupRows.isEmpty) {
        return;
      }
      widgets.add(
        Container(
          decoration: BoxDecoration(
            color: KaloriColors.surfaceContainerLowest,
            borderRadius: KaloriRadius.borderLg,
            border: Border.all(color: KaloriColors.borderSlate),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: groupRows),
        ),
      );
      groupRows = <Widget>[];
    }

    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      if (e.date.month != month || e.date.year != year) {
        flush();
        month = e.date.month;
        year = e.date.year;
        widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(4.0, widgets.isEmpty ? 0 : KaloriSpacing.lg, 4.0, KaloriSpacing.xs),
            child: Semantics(
              header: true,
              child: Text(
                HistoryFormat.monthYear(e.date).toUpperCase(),
                style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant),
              ),
            ),
          ),
        );
      }
      if (groupRows.isNotEmpty) {
        groupRows.add(Divider(color: KaloriColors.borderSlate, height: 1.0, indent: 16.0, endIndent: 16.0));
      }
      groupRows.add(
        _EntryRow(
          entry: e,
          previous: i == 0 ? null : entries[i - 1],
          goal: profile.goal,
          isFirst: i == 0,
          isToday: e.date.dateOnly == today,
          onTap: () => controller.editEntry(e),
          onDelete: () => controller.deleteEntry(e),
        ),
      );
    }
    flush();
    return widgets;
  }
}

class _Summary extends StatelessWidget {
  final UserProfile profile;
  final List<WeightEntry> entries;

  const _Summary({required this.profile, required this.entries});

  @override
  Widget build(BuildContext context) {
    final first = entries.first;
    final change = entries.last.kg - first.kg;
    final good = _isGood(change, profile.goal);
    final changeText = change.abs() < 0.05
        ? 'No change since ${HistoryFormat.shortDate(first.date)}'
        : '${change < 0 ? '−' : '+'}${ValueInputDialog.formatKg(change.abs())} kg since ${HistoryFormat.shortDate(first.date)}';

    return Container(
      padding: const EdgeInsets.fromLTRB(KaloriSpacing.containerMargin, 18.0, KaloriSpacing.containerMargin, 18.0),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: KaloriColors.borderSlate),
        boxShadow: [BoxShadow(color: KaloriColors.cardShadow, blurRadius: 20.0, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CURRENT WEIGHT', style: context.typography.labelCaps.copyWith(color: KaloriColors.onSurfaceVariant)),
                Text.rich(
                  TextSpan(
                    text: ValueInputDialog.formatKg(profile.weightKg),
                    style: context.typography.headlineLg.copyWith(fontSize: 36.0, height: 44.0 / 36.0),
                    children: [TextSpan(text: ' kg', style: context.typography.bodySm)],
                  ),
                ),
                Text(
                  changeText,
                  style: context.typography.bodySm.copyWith(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: good ? KaloriColors.primary : KaloriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '${entries.length} ${entries.length == 1 ? 'weigh-in' : 'weigh-ins'}'
                  '${profile.goal == GoalType.maintain ? '' : ' · goal ${ValueInputDialog.formatKg(profile.targetWeightKg)} kg'}',
                  style: context.typography.bodySm.copyWith(fontSize: 12.0, color: KaloriColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (entries.length >= 2)
            Semantics(
              label: 'Weight trend from ${ValueInputDialog.formatKg(first.kg)} to ${ValueInputDialog.formatKg(entries.last.kg)} kilograms',
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: WeightSparkline(values: [for (final e in entries) e.kg], width: 120.0),
              ),
            ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final WeightEntry entry;
  final WeightEntry? previous;
  final GoalType goal;
  final bool isFirst;
  final bool isToday;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EntryRow({
    required this.entry,
    required this.previous,
    required this.goal,
    required this.isFirst,
    required this.isToday,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final delta = previous == null ? null : entry.kg - previous!.kg;
    final weekday = HistoryFormat.weekday(entry.date).substring(0, 3);
    final dateText = '$weekday, ${HistoryFormat.shortDate(entry.date)}';

    String? deltaText;
    Color deltaColor = KaloriColors.onSurfaceVariant;
    if (delta != null) {
      if (delta.abs() < 0.05) {
        deltaText = 'no change';
      } else {
        deltaText = '${delta < 0 ? '−' : '+'}${ValueInputDialog.formatKg(delta.abs())}';
        if (_isGood(delta, goal)) {
          deltaColor = KaloriColors.primary;
        }
      }
    }

    return Dismissible(
      key: ValueKey(entry.date),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: KaloriColors.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: KaloriSpacing.lg),
        child: Icon(Icons.delete_outline_rounded, color: KaloriColors.onErrorContainer),
      ),
      child: Semantics(
        label: '$dateText, ${ValueInputDialog.formatKg(entry.kg)} kilograms'
            '${deltaText == null ? '' : ', $deltaText since previous'}',
        button: true,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            dateText,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w600, color: KaloriColors.onSurface),
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: KaloriSpacing.xs),
                          _Tag(label: 'TODAY', bg: KaloriColors.successTint, fg: KaloriColors.primary),
                        ] else if (isFirst) ...[
                          const SizedBox(width: KaloriSpacing.xs),
                          _Tag(label: 'START', bg: KaloriColors.surfaceContainerHigh, fg: KaloriColors.onSurfaceVariant),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${ValueInputDialog.formatKg(entry.kg)} kg',
                        style: context.typography.bodyLg.copyWith(fontWeight: FontWeight.w700, color: KaloriColors.onSurface),
                      ),
                      if (deltaText != null)
                        Text(
                          deltaText,
                          style: context.typography.bodySm.copyWith(fontSize: 12.0, fontWeight: FontWeight.w600, color: deltaColor),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _Tag({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(color: bg, borderRadius: KaloriRadius.borderFull),
      child: Text(
        label,
        style: context.typography.labelCaps.copyWith(fontSize: 10.0, height: 14.0 / 10.0, letterSpacing: 0.5, color: fg),
      ),
    );
  }
}

class _EmptyLog extends StatelessWidget {
  const _EmptyLog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(color: KaloriColors.surfaceContainerHigh, shape: BoxShape.circle),
              child: Icon(Icons.monitor_weight_outlined, size: 40.0, color: KaloriColors.primary),
            ),
            const SizedBox(height: KaloriSpacing.lg),
            Text('No weigh-ins yet', style: context.typography.headlineMd.copyWith(fontSize: 18.0, fontWeight: FontWeight.w700)),
            const SizedBox(height: KaloriSpacing.xs),
            Text(
              'Log your weight to start tracking your progress.',
              textAlign: TextAlign.center,
              style: context.typography.bodySm,
            ),
          ],
        ),
      ),
    );
  }
}

/// Whether a weight change moves toward the goal.
bool _isGood(double change, GoalType goal) {
  return switch (goal) {
    GoalType.lose => change < 0,
    GoalType.gain => change > 0,
    GoalType.maintain => false,
  };
}
