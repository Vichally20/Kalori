import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_theme.dart';
import 'package:kalori/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:kalori/features/onboarding/presentation/widgets/onboarding_common.dart';
import 'package:kalori/features/onboarding/presentation/widgets/onboarding_steps.dart';

/// First-run onboarding (Welcome → 4 data steps → Your plan).
///
/// Also opens a single step for editing from Profile via [OnboardingArgs].
class OnboardingView extends GetView<OnboardingController> {
  static String path = '/onboarding';

  const OnboardingView({super.key});

  static const Map<int, String> _editTitles = {
    OnboardingStep.about: 'Name, sex & age',
    OnboardingStep.body: 'Height & weight',
    OnboardingStep.activity: 'Activity',
    OnboardingStep.goal: 'Goal',
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.step.value;
      final editing = controller.isEditing;
      final isFirstStep = !editing && step == OnboardingStep.welcome;

      return PopScope(
        canPop: editing || isFirstStep,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            controller.back();
          }
        },
        child: Scaffold(
          backgroundColor: KaloriColors.background,
          appBar: editing
              ? AppBar(
                  backgroundColor: KaloriColors.background,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: false,
                  leading: IconButton(
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
                    onPressed: controller.back,
                  ),
                  title: Text(
                    _editTitles[controller.editStep] ?? 'Edit',
                    style: context.typography.headlineMd.copyWith(fontWeight: FontWeight.w700),
                  ),
                )
              : null,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!editing && step >= OnboardingStep.about && step <= OnboardingStep.goal)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(KaloriSpacing.xs, KaloriSpacing.md, KaloriSpacing.containerMargin, 0),
                    child: OnboardingStepHeader(current: step, onBack: controller.back),
                  ),
                if (!editing && step == OnboardingStep.plan)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(KaloriSpacing.xs, KaloriSpacing.md, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        tooltip: 'Back',
                        onPressed: controller.back,
                        icon: const Icon(Icons.arrow_back_rounded, color: KaloriColors.onSurface),
                      ),
                    ),
                  ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    // Pin steps to the top (the default layout centres them vertically).
                    layoutBuilder: (current, previous) => Stack(
                      fit: StackFit.expand,
                      children: [...previous, ?current],
                    ),
                    child: KeyedSubtree(key: ValueKey<int>(step), child: _stepFor(step)),
                  ),
                ),
                _BottomActions(step: step, editing: editing),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _stepFor(int step) {
    return switch (step) {
      OnboardingStep.welcome => const WelcomeStep(),
      OnboardingStep.about => const AboutStep(),
      OnboardingStep.body => const BodyStep(),
      OnboardingStep.activity => const ActivityStep(),
      OnboardingStep.goal => const GoalStep(),
      _ => const PlanStep(),
    };
  }
}

class _BottomActions extends GetView<OnboardingController> {
  final int step;
  final bool editing;

  const _BottomActions({required this.step, required this.editing});

  static final ButtonStyle _primary = ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52.0));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KaloriSpacing.containerMargin,
        KaloriSpacing.xs,
        KaloriSpacing.containerMargin,
        KaloriSpacing.containerMargin,
      ),
      child: Obx(() {
        final enabled = controller.canContinue && !controller.isSaving.value;

        if (editing) {
          return ElevatedButton(
            style: _primary,
            onPressed: enabled ? controller.saveEdit : null,
            child: const Text('Save'),
          );
        }

        switch (step) {
          case OnboardingStep.welcome:
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: _primary,
                  onPressed: controller.next,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Get started'), SizedBox(width: 8.0), Icon(Icons.arrow_forward_rounded)],
                  ),
                ),
                const SizedBox(height: KaloriSpacing.sm),
                Text(
                  'Takes about a minute. Your data stays on this phone.',
                  textAlign: TextAlign.center,
                  style: context.typography.bodySm.copyWith(fontSize: 13.0, color: KaloriColors.onSurfaceVariant),
                ),
              ],
            );
          case OnboardingStep.plan:
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: _primary,
                  onPressed: enabled ? controller.finish : null,
                  child: const Text('Start logging'),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () => controller.goToStep(OnboardingStep.goal),
                  child: const Text('Adjust my goal'),
                ),
              ],
            );
          default:
            return ElevatedButton(
              style: _primary,
              onPressed: enabled ? controller.next : null,
              child: Text(step == OnboardingStep.goal ? 'See my plan' : 'Continue'),
            );
        }
      }),
    );
  }
}
