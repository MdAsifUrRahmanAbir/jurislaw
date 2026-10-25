import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(DateTime date) => date.toIso8601String();

  /// API date format — `Y-m-d`.
  static String apiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  /// `21 Aug 2026`
  static String day(DateTime date) => DateFormat('d MMM yyyy').format(date);

  /// `Thu, 21 Aug`
  static String shortDay(DateTime date) => DateFormat('EEE, d MMM').format(date);

  /// `10:00 AM`
  static String time(DateTime date) => DateFormat('h:mm a').format(date);

  /// `21 Aug 2026, 10:00 AM`
  static String dayTime(DateTime date) => '${day(date)}, ${time(date)}';

  /// Turns an API `H:i` (or `H:i:s`) time string into `10:00 AM`.
  static String clock(String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return '';
    final parts = hhmm.split(':');
    final hour = int.tryParse(parts.first);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    if (hour == null) return hhmm;
    return time(DateTime(2000, 1, 1, hour, minute));
  }

  /// `just now`, `5m ago`, `3h ago`, `2d ago`, then a plain date.
  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return day(date);
  }

  /// `02:14` / `1:02:14` countdown text.
  static String countdown(Duration d) {
    if (d.isNegative) return '00:00';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }
}
