import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Data class representing a single statistic card inside [GenericQuickStatsRow].
class StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });
}

/// A generic, reusable horizontal row of quick statistic cards (`GenericQuickStatsRow`).
///
/// Can be used either with custom stat items (`stats: [StatCardData(...), ...]`)
/// or convenient daily summary fields (`eaten`, `burned`, `net`).
class GenericQuickStatsRow extends StatelessWidget {
  /// Optional custom list of statistic items. If null or empty, builds default stats
  /// using [eaten], [burned], and [net].
  final List<StatCardData>? stats;

  /// Convenience parameter for daily eaten calories.
  final int? eaten;

  /// Convenience parameter for daily burned calories.
  final int? burned;

  /// Convenience parameter for daily net calories.
  final int? net;

  /// Optional string override for eaten value text.
  final String? eatenText;

  /// Optional string override for burned value text.
  final String? burnedText;

  /// Optional string override for net value text.
  final String? netText;

  const GenericQuickStatsRow({
    super.key,
    this.stats,
    this.eaten,
    this.burned,
    this.net,
    this.eatenText,
    this.burnedText,
    this.netText,
  });

  @override
  Widget build(BuildContext context) {
    final List<StatCardData> resolvedStats = stats ?? _resolveConvenienceStats();

    if (resolvedStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: resolvedStats.asMap().entries.map((entry) {
        final int idx = entry.key;
        final StatCardData item = entry.value;

        return Expanded(
          child: Row(
            children: [
              if (idx > 0) const SizedBox(width: KaloriSpacing.gutter),
              Expanded(child: _buildStatCard(context, item)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<StatCardData> _resolveConvenienceStats() {
    if (eaten == null && burned == null && net == null &&
        eatenText == null && burnedText == null && netText == null) {
      return const [];
    }

    return [
      StatCardData(
        label: 'EATEN',
        value: eatenText ?? (eaten?.toString() ?? '0'),
        icon: Icons.restaurant_outlined,
        iconColor: KaloriColors.primary,
      ),
      StatCardData(
        label: 'BURNED',
        value: burnedText ?? (burned?.toString() ?? '0'),
        icon: Icons.local_fire_department_outlined,
        iconColor: KaloriColors.secondary,
      ),
      StatCardData(
        label: 'NET',
        value: netText ?? (net?.toString() ?? '0'),
        icon: Icons.balance_outlined,
        iconColor: KaloriColors.tertiary,
      ),
    ];
  }

  Widget _buildStatCard(BuildContext context, StatCardData item) {
    final Widget card = Container(
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(KaloriRadius.lg),
        border: Border.all(color: KaloriColors.borderSlate, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: KaloriColors.cardShadow,
            blurRadius: 16.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: KaloriSpacing.md,
        horizontal: KaloriSpacing.xs,
      ),
      child: Column(
        children: [
          Icon(item.icon, color: item.iconColor, size: 24.0),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: context.typography.labelCaps.copyWith(
              color: KaloriColors.outline,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: context.typography.headlineLgMobile.copyWith(
              color: KaloriColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (item.onTap != null) {
      return GestureDetector(
        onTap: item.onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }

    return card;
  }
}
