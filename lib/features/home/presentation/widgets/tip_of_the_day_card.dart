import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';

/// Dark "Tip of the day" card. The tip rotates daily through a fixed list of
/// general nutrition tips (editorial content, not user data).
class TipOfTheDayCard extends StatelessWidget {
  const TipOfTheDayCard({super.key});

  static const List<(String, String)> tips = [
    ('Boost your fiber with chia seeds in your next snack.', 'Fiber helps you stay full for longer.'),
    ('Swap fried plantain for boiled or roasted once this week.', 'Same taste you love, far less oil.'),
    ('Add beans or moi moi to one meal today.', 'An easy, affordable protein boost.'),
    ('Drink a glass of water before each meal.', 'Thirst is often mistaken for hunger.'),
    ('Fill half your plate with vegetables at dinner.', 'More volume and nutrients for fewer calories.'),
    ('Measure your oil with a spoon when cooking soup.', 'Palm and vegetable oil add up quickly.'),
    ('Choose fruit over a sugary drink this afternoon.', 'You keep the sweetness and gain fiber.'),
    ('Log your meal right after you eat it.', 'Logging straight away makes portions easier to remember.'),
    ('Try a smaller wrap of swallow with more soup and protein.', 'Balances your carbs and keeps you satisfied.'),
    ('Take a 10-minute walk after your largest meal.', 'Gentle movement helps your body manage blood sugar.'),
  ];

  /// Same tip all day, a new one tomorrow.
  static (String, String) tipFor(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year)).inDays;
    return tips[dayOfYear % tips.length];
  }

  @override
  Widget build(BuildContext context) {
    final (title, body) = tipFor(DateTime.now());
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: KaloriColors.inverseSurface,
        borderRadius: BorderRadius.circular(KaloriRadius.lg),
        boxShadow: [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 20.0,
            offset: const Offset(0, 6),
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
            title,
            style: context.typography.headlineMd.copyWith(
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: KaloriSpacing.xs),
          Text(
            body,
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
