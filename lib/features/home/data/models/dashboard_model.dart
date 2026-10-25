import '../../../../core/utils/json_utils.dart';
import '../../../bookings/data/models/booking_model.dart';

class DashboardStat {
  final String key;
  final String label;
  final String value;

  const DashboardStat({required this.key, required this.label, required this.value});
}

/// A3.1 — `stats`, `today`, and up to 5 `upcoming` consultations.
class DashboardModel {
  final List<DashboardStat> stats;
  final List<BookingModel> today;
  final List<BookingModel> upcoming;

  const DashboardModel({this.stats = const [], this.today = const [], this.upcoming = const []});

  List<BookingModel> get needsResponse => upcoming.where((b) => b.needsResponse).toList();

  static const _labels = {
    'total': 'Total',
    'total_bookings': 'Total Bookings',
    'upcoming': 'Upcoming',
    'pending': 'Pending',
    'pending_payment': 'Awaiting Payment',
    'pending_advocate': 'Awaiting Advocate',
    'confirmed': 'Confirmed',
    'completed': 'Completed',
    'cancelled': 'Cancelled',
    'total_spent': 'Total Spent',
    'spent': 'Total Spent',
  };

  factory DashboardModel.fromData(Map<String, dynamic> data) {
    final stats = <DashboardStat>[];
    final rawStats = Json.pick(data, const ['stats', 'counts']);
    if (rawStats is Map) {
      rawStats.forEach((key, value) {
        if (value is Map) {
          final json = Map<String, dynamic>.from(value);
          stats.add(DashboardStat(
            key: key.toString(),
            label: Json.string(json, const ['label', 'title'], _label(key.toString())),
            value: Json.string(json, const ['value', 'count']),
          ));
        } else if (value is num || value is String) {
          stats.add(DashboardStat(key: key.toString(), label: _label(key.toString()), value: value.toString()));
        }
      });
    } else if (rawStats is List) {
      for (final item in rawStats.whereType<Map>()) {
        final json = Map<String, dynamic>.from(item);
        final key = Json.string(json, const ['key', 'label']);
        stats.add(DashboardStat(key: key, label: Json.string(json, const ['label', 'title'], _label(key)), value: Json.string(json, const ['value', 'count'])));
      }
    }

    // `today` may be a list of consultations or an object holding one.
    final rawToday = Json.pick(data, const ['today']);
    List<Map<String, dynamic>> todayRows = const [];
    if (rawToday is List) {
      todayRows = rawToday.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (rawToday is Map) {
      final json = Map<String, dynamic>.from(rawToday);
      todayRows = json.containsKey('id') ? [json] : Json.maps(json, const ['bookings', 'consultations', 'items']);
    }

    return DashboardModel(
      stats: stats,
      today: todayRows.map(BookingModel.fromJson).toList(),
      upcoming: Json.maps(data, const ['upcoming']).map(BookingModel.fromJson).toList(),
    );
  }

  static String _label(String key) {
    if (_labels.containsKey(key)) return _labels[key]!;
    final text = key.replaceAll('_', ' ');
    return text.isEmpty ? key : text[0].toUpperCase() + text.substring(1);
  }

  /// Stats with a money-looking key are shown as Taka.
  static bool isMoney(String key) => key.contains('spent') || key.contains('amount') || key.contains('paid');
}
