import 'package:ukil_chaai_client/app/data/models/lawyer_model.dart';

/// GET /advocates  (A4.1)
class AdvocateListModel {
  final List<Advocate> data;
  final int currentPage;
  final int lastPage;
  final int total;

  AdvocateListModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory AdvocateListModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? [])
        .map((e) => Advocate.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    // Laravel puts pagination either in `meta` or at the top level.
    final meta = (json['meta'] is Map) ? Map<String, dynamic>.from(json['meta']) : json;
    final current = _toInt(meta['current_page']) ?? 1;
    return AdvocateListModel(
      data: list,
      currentPage: current,
      lastPage: _toInt(meta['last_page']) ?? (list.length >= 15 ? current + 1 : current),
      total: _toInt(meta['total']) ?? list.length,
    );
  }
}

class Advocate {
  final int id;
  final String name;
  final String profilePhoto;
  final int yearsOfExperience;
  final List<String> practiceAreas;
  final String shortBio;
  final String division;
  final String district;
  final String upazila;
  final String barCouncilEnrollmentNumber;
  final double? startingPrice;

  Advocate({
    required this.id,
    required this.name,
    required this.profilePhoto,
    required this.yearsOfExperience,
    required this.practiceAreas,
    required this.shortBio,
    required this.division,
    required this.district,
    required this.upazila,
    required this.barCouncilEnrollmentNumber,
    required this.startingPrice,
  });

  factory Advocate.fromJson(Map<String, dynamic> json) => Advocate(
        id: _toInt(json['id']) ?? 0,
        name: json['name']?.toString() ?? '',
        profilePhoto: (json['profile_photo_url'] ?? json['profile_photo'])?.toString() ?? '',
        yearsOfExperience: _toInt(json['years_of_experience']) ?? 0,
        practiceAreas: _toStringList(json['practice_areas']),
        shortBio: (json['short_bio'] ?? json['bio'])?.toString() ?? '',
        division: json['division']?.toString() ?? '',
        district: json['district']?.toString() ?? '',
        upazila: json['upazila']?.toString() ?? '',
        barCouncilEnrollmentNumber: json['bar_council_enrollment_number']?.toString() ?? '',
        startingPrice: _toDouble(json['starting_price']),
      );

  String get location =>
      [upazila, district, division].where((e) => e.isNotEmpty).toSet().join(', ');

  /// Bridges the API model to the UI model used by LawyerCard / LawyerDetails.
  Lawyer toLawyer() => Lawyer(
        id: id.toString(),
        name: name,
        photo: profilePhoto,
        specialty: practiceAreas.isNotEmpty ? practiceAreas.first : '',
        experience: yearsOfExperience,
        location: location,
        rating: 0,
        reviewsCount: 0,
        bio: shortBio,
        specialties: practiceAreas,
        practiceAreas: practiceAreas,
        fee: startingPrice ?? 0,
        barEnrollment: barCouncilEnrollmentNumber,
        availability: startingPrice == null ? 'No open slots' : 'Available',
      );
}

/// GET /advocates/filters  (A4.2)
class AdvocateFiltersModel {
  final List<String> practiceAreas;
  final List<String> divisions;
  final List<String> districts;
  final List<String> sorts;

  AdvocateFiltersModel({
    required this.practiceAreas,
    required this.divisions,
    required this.districts,
    required this.sorts,
  });

  factory AdvocateFiltersModel.fromJson(Map<String, dynamic> json) {
    final d = (json['data'] is Map) ? Map<String, dynamic>.from(json['data']) : json;
    final sorts = _toStringList(d['sorts']);
    return AdvocateFiltersModel(
      practiceAreas: _toStringList(d['practice_areas']),
      divisions: _toStringList(d['divisions']),
      districts: _toStringList(d['districts']),
      sorts: sorts.isEmpty
          ? const ['recommended', 'experience', 'price_low', 'price_high', 'name']
          : sorts,
    );
  }
}

// ── Parsing helpers ─────────────────────────────────────────────────────────
int? _toInt(dynamic v) => v == null ? null : int.tryParse(v.toString());

double? _toDouble(dynamic v) => v == null ? null : double.tryParse(v.toString());

/// Accepts ["a","b"], [{"value":"a"}], [{"key":"a","label":"A"}] or a JSON-ish string.
List<String> _toStringList(dynamic v) {
  if (v is List) {
    return v
        .map((e) {
          if (e is Map) return (e['value'] ?? e['key'] ?? e['name'] ?? e['label'])?.toString();
          return e?.toString();
        })
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toList();
  }
  if (v is String && v.isNotEmpty) {
    return v
        .replaceAll(RegExp(r'[\[\]"]'), '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return [];
}
