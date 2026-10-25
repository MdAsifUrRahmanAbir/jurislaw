/// Tolerant JSON readers used by every API model.
///
/// The backend's exact response shapes are not pinned down yet (only the
/// field names in the API reference), so models read through these helpers
/// instead of hard casts: a missing key, a number sent as a string, or a
/// `1`/`"1"` boolean never throws — it falls back to a safe default.
/// Each reader also accepts several candidate keys, first match wins.
class Json {
  Json._();

  static dynamic pick(Map<String, dynamic>? json, List<String> keys) {
    if (json == null) return null;
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value;
    }
    return null;
  }

  static String string(Map<String, dynamic>? json, List<String> keys, [String fallback = '']) {
    final value = pick(json, keys);
    if (value == null) return fallback;
    return value.toString();
  }

  static String? stringOrNull(Map<String, dynamic>? json, List<String> keys) {
    final value = pick(json, keys);
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }

  static int integer(Map<String, dynamic>? json, List<String> keys, [int fallback = 0]) =>
      toInt(pick(json, keys)) ?? fallback;

  static int? intOrNull(Map<String, dynamic>? json, List<String> keys) => toInt(pick(json, keys));

  static double number(Map<String, dynamic>? json, List<String> keys, [double fallback = 0]) =>
      toDouble(pick(json, keys)) ?? fallback;

  static double? numberOrNull(Map<String, dynamic>? json, List<String> keys) => toDouble(pick(json, keys));

  static bool boolean(Map<String, dynamic>? json, List<String> keys, [bool fallback = false]) {
    final value = pick(json, keys);
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value.toString().toLowerCase();
    return text == 'true' || text == '1' || text == 'yes';
  }

  static DateTime? date(Map<String, dynamic>? json, List<String> keys) => toDate(pick(json, keys));

  static Map<String, dynamic>? map(Map<String, dynamic>? json, List<String> keys) {
    final value = pick(json, keys);
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static List<dynamic> list(Map<String, dynamic>? json, List<String> keys) {
    final value = pick(json, keys);
    return value is List ? value : const [];
  }

  static List<Map<String, dynamic>> maps(Map<String, dynamic>? json, List<String> keys) => [
        for (final item in list(json, keys))
          if (item is Map) Map<String, dynamic>.from(item),
      ];

  /// A list of plain strings. Also accepts a list of objects (takes their
  /// `name`/`label`/`title`) or a single comma-separated string.
  static List<String> strings(Map<String, dynamic>? json, List<String> keys) {
    final value = pick(json, keys);
    if (value is String) {
      return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is Map)
          (item['name'] ?? item['label'] ?? item['title'] ?? item['value'] ?? '').toString()
        else if (item != null)
          item.toString(),
    ].where((e) => e.isNotEmpty).toList();
  }

  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? double.tryParse(value.toString())?.toInt();
  }

  static double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', ''));
  }

  static DateTime? toDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text)?.toLocal() ?? DateTime.tryParse(text.replaceFirst(' ', 'T'))?.toLocal();
  }

  /// The `data` object of a `{data: {...}, message}` response body.
  static Map<String, dynamic> data(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return Map<String, dynamic>.from(body);
    }
    return const {};
  }

  /// The human-readable `message` of an action response, if any.
  static String? message(dynamic body) {
    if (body is Map && body['message'] != null) return body['message'].toString();
    return null;
  }
}
