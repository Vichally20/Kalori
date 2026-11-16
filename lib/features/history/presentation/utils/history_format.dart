/// Lightweight date and number formatting for History (no intl dependency).
class HistoryFormat {
  HistoryFormat._();

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Sunday-first initials, matching the calendar and week chart columns.
  static const List<String> weekdayInitials = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  /// `1250` -> `1,250`.
  static String number(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return value < 0 ? '-$buffer' : buffer.toString();
  }

  /// `October 2026`
  static String monthYear(DateTime date) => '${_months[date.month - 1]} ${date.year}';

  /// `Oct 2026`
  static String shortMonthYear(DateTime date) => '${_months[date.month - 1].substring(0, 3)} ${date.year}';

  /// `Oct 23`
  static String shortDate(DateTime date) => '${_months[date.month - 1].substring(0, 3)} ${date.day}';

  /// `October 23`
  static String longDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

  /// `Friday`
  static String weekday(DateTime date) => _weekdays[date.weekday - 1];

  /// `Oct 18 – 24` or `Sep 27 – Oct 3`
  static String weekRange(DateTime start, DateTime end) {
    if (start.month == end.month) {
      return '${shortDate(start)} – ${end.day}';
    }
    return '${shortDate(start)} – ${shortDate(end)}';
  }

  /// `8:10 AM`
  static String time(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
