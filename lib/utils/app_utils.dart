
class AppUtils {
  /// Returns the number of weeks between two dates
  static int weeksBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    if (from.isAfter(to)) {
      final temp = from;
      from = to;
      to = temp;
    }
    return (to.difference(from).inDays / 7).ceil();
  }

  /// Returns the week number of the given date
  static int weekNumber(final DateTime date) {
    final now = DateTime(date.year, date.month, date.day);
    final firstJan = DateTime(date.year, 1, 1);
    final weekNumber = weeksBetween(firstJan, now);
    return weekNumber;
  }

  /// Returns the current week number
  static int currentWeekNumber() {
    return weekNumber(DateTime.now());
  }
}
