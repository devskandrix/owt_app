/// Time labels for the Messages and Chat screens.
abstract final class ChatTime {
  /// "09:25 AM".
  static String clock(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  /// How long ago, in one unit: "now", "5m", "4h", "2d", "3w".
  static String ago(DateTime time, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${diff.inDays ~/ 7}w';
  }

  static DateTime fromMillis(int millis) =>
      DateTime.fromMillisecondsSinceEpoch(millis);

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Date header in a chat: "Today", "Yesterday", a weekday within the
  /// last week, otherwise "12 Oct 2026".
  static String dateLabel(DateTime time, {DateTime? now}) {
    final today = _day(now ?? DateTime.now());
    final days = today.difference(_day(time)).inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days > 1 && days < 7) return _weekdays[time.weekday - 1];
    return '${time.day} ${_months[time.month - 1]} ${time.year}';
  }

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

  /// "00:16" for a duration in seconds.
  static String duration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
