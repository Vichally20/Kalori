/// Aggregate numbers for a range of days (a week or a month).
class PeriodStats {
  /// Days in the range up to and including today.
  final int elapsedDays;

  /// Days in the range (up to today) with at least one analysed meal.
  final int loggedDays;

  /// Past days with logs; the base for averages (today and missed days are left out).
  final int completedDays;

  final int onTrack;
  final int close;
  final int over;
  final int missed;

  /// Averages over [completedDays]; 0 when there are none.
  final int averageCalories;
  final int averageCarbs;
  final int averageProtein;
  final int averageFat;

  const PeriodStats({
    required this.elapsedDays,
    required this.loggedDays,
    required this.completedDays,
    required this.onTrack,
    required this.close,
    required this.over,
    required this.missed,
    required this.averageCalories,
    required this.averageCarbs,
    required this.averageProtein,
    required this.averageFat,
  });

  bool get hasAverage => completedDays > 0;
}
