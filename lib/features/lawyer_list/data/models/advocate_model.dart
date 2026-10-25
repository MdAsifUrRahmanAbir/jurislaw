import '../../../../core/utils/json_utils.dart';

/// One bookable slot from A4.3 (`slots[]`) / A4.4. Book it with
/// POST /schedules/{id}/book.
class AdvocateSlot {
  final String id;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final double price;
  final String? sessionType;
  final int? durationMinutes;

  const AdvocateSlot({
    required this.id,
    this.date,
    this.startTime = '',
    this.endTime = '',
    this.price = 0,
    this.sessionType,
    this.durationMinutes,
  });

  /// Full start time, from `starts_at` when sent, else date + start_time.
  DateTime? get startsAt => _combine(startTime);
  DateTime? get endsAt => _combine(endTime);

  DateTime? _combine(String hhmm) {
    if (date == null) return null;
    final parts = hhmm.split(':');
    final hour = int.tryParse(parts.first);
    if (hour == null) return date;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date!.year, date!.month, date!.day, hour, minute);
  }

  factory AdvocateSlot.fromJson(Map<String, dynamic> json) {
    final startsAt = Json.date(json, const ['starts_at', 'start_at', 'start_datetime']);
    final endsAt = Json.date(json, const ['ends_at', 'end_at', 'end_datetime']);
    String hhmm(DateTime? d) =>
        d == null ? '' : '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return AdvocateSlot(
      id: Json.string(json, const ['id', 'schedule_id', 'slot_id']),
      date: Json.date(json, const ['date', 'slot_date', 'schedule_date']) ?? startsAt,
      startTime: Json.stringOrNull(json, const ['start_time', 'from', 'time_from']) ?? hhmm(startsAt),
      endTime: Json.stringOrNull(json, const ['end_time', 'to', 'time_to']) ?? hhmm(endsAt),
      price: Json.number(json, const ['price', 'fee', 'amount', 'consultation_fee']),
      sessionType: Json.stringOrNull(json, const ['session_type_label', 'session_type', 'type']),
      durationMinutes: Json.intOrNull(json, const ['duration', 'duration_minutes']),
    );
  }
}

/// A row of the directory (A4.1). Phone and email are never part of it —
/// they are exchanged inside the paid session.
class AdvocateSummary {
  final String id;
  final String name;
  final String? photoUrl;
  final String? division;
  final String? district;
  final List<String> practiceAreas;
  final String bio;
  final int experienceYears;
  final double? startingPrice;
  final bool isVerified;
  final double? rating;

  const AdvocateSummary({
    required this.id,
    required this.name,
    this.photoUrl,
    this.division,
    this.district,
    this.practiceAreas = const [],
    this.bio = '',
    this.experienceYears = 0,
    this.startingPrice,
    this.isVerified = true,
    this.rating,
  });

  /// `Dhaka, Dhaka` — district then division, like the web card.
  String get location => [district, division].where((e) => e != null && e.isNotEmpty).join(', ');

  /// `starting_price` is null when nothing is bookable right now.
  bool get hasOpenSlots => startingPrice != null;

  factory AdvocateSummary.fromJson(Map<String, dynamic> json) {
    final user = Json.map(json, const ['user']);
    return AdvocateSummary(
      id: Json.string(json, const ['id', 'advocate_id']),
      name: Json.stringOrNull(json, const ['name', 'full_name']) ?? Json.string(user, const ['name']),
      photoUrl: Json.stringOrNull(json, const ['profile_photo_url', 'photo_url', 'photo', 'avatar', 'profile_photo']),
      division: Json.stringOrNull(json, const ['division']),
      district: Json.stringOrNull(json, const ['district']),
      practiceAreas: Json.strings(json, const ['practice_areas', 'practiceAreas', 'specializations']),
      bio: Json.string(json, const ['bio', 'about', 'description']),
      experienceYears: Json.integer(json, const ['experience_years', 'years_of_experience', 'experience']),
      startingPrice: Json.numberOrNull(json, const ['starting_price', 'min_price']),
      isVerified: Json.boolean(json, const ['is_verified', 'verified'], true),
      rating: Json.numberOrNull(json, const ['rating', 'average_rating']),
    );
  }
}

/// A4.3 — the profile plus the next 20 open slots inline.
class AdvocateDetail extends AdvocateSummary {
  final List<AdvocateSlot> slots;
  final bool hasMoreSlots;
  final String? education;
  final String? barEnrollment;
  final String? court;
  final String? chamber;
  final List<String> languages;

  const AdvocateDetail({
    required super.id,
    required super.name,
    super.photoUrl,
    super.division,
    super.district,
    super.practiceAreas,
    super.bio,
    super.experienceYears,
    super.startingPrice,
    super.isVerified,
    super.rating,
    this.slots = const [],
    this.hasMoreSlots = false,
    this.education,
    this.barEnrollment,
    this.court,
    this.chamber,
    this.languages = const [],
  });

  factory AdvocateDetail.fromData(Map<String, dynamic> data) {
    // The profile can be the whole `data`, or nested under `advocate`.
    final json = Json.map(data, const ['advocate', 'profile']) ?? data;
    final base = AdvocateSummary.fromJson(json);
    final rawSlots = Json.maps(data, const ['slots', 'open_slots', 'schedules']);
    final slots = rawSlots.isNotEmpty ? rawSlots : Json.maps(json, const ['slots', 'open_slots', 'schedules']);
    return AdvocateDetail(
      id: base.id,
      name: base.name,
      photoUrl: base.photoUrl,
      division: base.division,
      district: base.district,
      practiceAreas: base.practiceAreas,
      bio: base.bio,
      experienceYears: base.experienceYears,
      startingPrice: base.startingPrice,
      isVerified: base.isVerified,
      rating: base.rating,
      slots: slots.map(AdvocateSlot.fromJson).toList(),
      hasMoreSlots: Json.boolean(data, const ['has_more_slots']) || Json.boolean(json, const ['has_more_slots']),
      education: Json.stringOrNull(json, const ['education', 'qualification', 'qualifications']),
      barEnrollment: Json.stringOrNull(json, const ['bar_council_no', 'enrollment_no', 'bar_enrollment', 'bar_council_enrollment', 'license_no']),
      court: Json.stringOrNull(json, const ['court', 'practicing_court', 'court_name']),
      chamber: Json.stringOrNull(json, const ['chamber_address', 'chamber', 'address']),
      languages: Json.strings(json, const ['languages']),
    );
  }
}

class SortOption {
  final String value;
  final String label;
  const SortOption(this.value, this.label);
}

/// A4.2 — filter values built from the live roster.
class AdvocateFilters {
  final List<String> practiceAreas;
  final List<String> divisions;
  final List<String> districts;
  final Map<String, List<String>> districtsByDivision;
  final List<SortOption> sorts;
  final double? minPrice;
  final double? maxPrice;
  final List<String> sessionTypes;

  const AdvocateFilters({
    this.practiceAreas = const [],
    this.divisions = const [],
    this.districts = const [],
    this.districtsByDivision = const {},
    this.sorts = defaultSorts,
    this.minPrice,
    this.maxPrice,
    this.sessionTypes = const [],
  });

  static const defaultSorts = [
    SortOption('recommended', 'Recommended'),
    SortOption('experience', 'Most experienced'),
    SortOption('price_low', 'Price: low to high'),
    SortOption('price_high', 'Price: high to low'),
    SortOption('name', 'Name (A–Z)'),
  ];

  List<String> districtsFor(String? division) {
    if (division != null && districtsByDivision[division] != null) return districtsByDivision[division]!;
    return districts;
  }

  factory AdvocateFilters.fromData(Map<String, dynamic> data) {
    final byDivision = <String, List<String>>{};
    final rawDistricts = Json.pick(data, const ['districts']);
    var districts = <String>[];
    if (rawDistricts is Map) {
      // `{Dhaka: [Dhaka, Gazipur], ...}`
      rawDistricts.forEach((key, value) {
        if (value is List) byDivision[key.toString()] = value.map((e) => e.toString()).toList();
      });
      districts = byDivision.values.expand((e) => e).toSet().toList()..sort();
    } else {
      districts = Json.strings(data, const ['districts']);
      for (final item in Json.maps(data, const ['districts'])) {
        final division = Json.stringOrNull(item, const ['division']);
        final name = Json.stringOrNull(item, const ['name', 'district']);
        if (division != null && name != null) byDivision.putIfAbsent(division, () => []).add(name);
      }
    }

    final sorts = <SortOption>[];
    final rawSorts = Json.pick(data, const ['sorts', 'sort_options']);
    if (rawSorts is Map) {
      rawSorts.forEach((key, value) => sorts.add(SortOption(key.toString(), value.toString())));
    } else if (rawSorts is List) {
      for (final item in rawSorts) {
        if (item is Map) {
          final value = (item['value'] ?? item['key'] ?? item['id'] ?? '').toString();
          if (value.isNotEmpty) sorts.add(SortOption(value, (item['label'] ?? item['name'] ?? value).toString()));
        } else if (item != null) {
          final value = item.toString();
          final known = defaultSorts.where((s) => s.value == value);
          sorts.add(known.isNotEmpty ? known.first : SortOption(value, value));
        }
      }
    }

    final price = Json.map(data, const ['price_range']);
    final priceList = Json.list(data, const ['price_range']);

    return AdvocateFilters(
      practiceAreas: Json.strings(data, const ['practice_areas']),
      divisions: Json.strings(data, const ['divisions']).isNotEmpty
          ? Json.strings(data, const ['divisions'])
          : byDivision.keys.toList(),
      districts: districts,
      districtsByDivision: byDivision,
      sorts: sorts.isEmpty ? defaultSorts : sorts,
      minPrice: Json.numberOrNull(price, const ['min', 'minimum']) ?? (priceList.isNotEmpty ? Json.toDouble(priceList.first) : null),
      maxPrice: Json.numberOrNull(price, const ['max', 'maximum']) ?? (priceList.length > 1 ? Json.toDouble(priceList[1]) : null),
      sessionTypes: Json.strings(data, const ['session_types']),
    );
  }
}
