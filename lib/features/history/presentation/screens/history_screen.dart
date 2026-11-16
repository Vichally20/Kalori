import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/history/presentation/controllers/history_controller.dart';
import 'package:kalori/features/history/presentation/widgets/history_common.dart';
import 'package:kalori/features/history/presentation/widgets/history_month_view.dart';
import 'package:kalori/features/history/presentation/widgets/history_week_view.dart';

/// History tab. Opens on the Month calendar; tapping a day opens [HistoryDayView].
class HistoryView extends GetView<HistoryController> {
  static String path = '/history';

  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            KaloriSpacing.containerMargin,
            KaloriSpacing.md,
            KaloriSpacing.containerMargin,
            KaloriSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 44.0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('History', style: context.typography.headlineLgMobile),
                ),
              ),
              const SizedBox(height: KaloriSpacing.containerMargin),
              Obx(
                () => HistoryRangeSwitch(
                  value: controller.range.value,
                  onChanged: controller.setRange,
                ),
              ),
              const SizedBox(height: KaloriSpacing.md),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: Center(child: CircularProgressIndicator(color: KaloriColors.primary)),
                  );
                }
                return switch (controller.range.value) {
                  HistoryRange.month => const HistoryMonthView(),
                  HistoryRange.week => const HistoryWeekView(),
                };
              }),
            ],
          ),
        ),
      ),
    );
  }
}
