import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TipOfTheDayCard extends StatelessWidget {
  const TipOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: KaloriColors.inverseSurface,
        borderRadius: BorderRadius.circular(KaloriRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 20.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(KaloriSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIP OF THE DAY',
            style: context.typography.labelCaps.copyWith(
              color: KaloriColors.inversePrimary,
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            'Boost your fiber with chia seeds in your next snack.',
            style: context.typography.headlineMd.copyWith(
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            'Helps maintain satiety for up to 4 hours longer.',
            style: context.typography.bodySm.copyWith(
              color: KaloriColors.outlineVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
