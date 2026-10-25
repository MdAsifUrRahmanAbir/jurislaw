import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/advocate_model.dart';

final advocateRepositoryProvider = Provider<AdvocateRepository>((ref) {
  return AdvocateRepository(ref.watch(apiClientProvider));
});

/// Query for GET /advocates (A4.1). Empty values are left out of the URL.
class AdvocateQuery {
  final String sort;
  final String q;
  final String? practiceArea;
  final String? division;
  final String? district;
  final bool availableOnly;

  const AdvocateQuery({
    this.sort = 'recommended',
    this.q = '',
    this.practiceArea,
    this.division,
    this.district,
    this.availableOnly = false,
  });

  bool get hasFilters =>
      q.isNotEmpty || practiceArea != null || division != null || district != null || availableOnly;

  int get activeFilterCount =>
      [practiceArea, division, district].where((e) => e != null).length + (availableOnly ? 1 : 0);

  AdvocateQuery copyWith({
    String? sort,
    String? q,
    String? practiceArea,
    bool clearPracticeArea = false,
    String? division,
    bool clearDivision = false,
    String? district,
    bool clearDistrict = false,
    bool? availableOnly,
  }) {
    return AdvocateQuery(
      sort: sort ?? this.sort,
      q: q ?? this.q,
      practiceArea: clearPracticeArea ? null : (practiceArea ?? this.practiceArea),
      division: clearDivision ? null : (division ?? this.division),
      district: clearDistrict ? null : (district ?? this.district),
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }

  Map<String, dynamic> toParams(int page) => {
        'sort': sort,
        if (q.trim().isNotEmpty) 'q': q.trim(),
        'practice_area': ?practiceArea,
        'division': ?division,
        'district': ?district,
        if (availableOnly) 'available_only': 1,
        'page': page,
      };
}

class AdvocateRepository {
  final ApiClient _apiClient;
  AdvocateRepository(this._apiClient);

  /// GET /advocates — verified advocates only, 15 per page.
  Future<PaginatedResponse<AdvocateSummary>> fetchAdvocates(AdvocateQuery query, {int page = 1}) async {
    final response = await _apiClient.get(ApiEndpoints.advocateList, queryParameters: query.toParams(page));
    return PaginatedResponse.fromBody(
      response.data,
      AdvocateSummary.fromJson,
      requestedPage: page,
      perPage: 15,
      listKeys: const ['data', 'advocates'],
    );
  }

  /// GET /advocates/filters
  Future<AdvocateFilters> fetchFilters() async {
    final response = await _apiClient.get(ApiEndpoints.advocateFilters);
    return AdvocateFilters.fromData(Json.data(response.data));
  }

  /// GET /advocates/{id} — 404 when the advocate is not verified.
  Future<AdvocateDetail> fetchAdvocate(String advocateId) async {
    final response = await _apiClient.get(ApiEndpoints.advocateDetail(advocateId));
    return AdvocateDetail.fromData(Json.data(response.data));
  }

  /// GET /advocates/{id}/slots — bookable slots only, 15 per page.
  Future<PaginatedResponse<AdvocateSlot>> fetchSlots(
    String advocateId, {
    DateTime? from,
    DateTime? to,
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.advocateSlots(advocateId),
      queryParameters: {
        if (from != null) 'from': DateFormatter.apiDate(from),
        if (to != null) 'to': DateFormatter.apiDate(to),
        'page': page,
      },
    );
    return PaginatedResponse.fromBody(
      response.data,
      AdvocateSlot.fromJson,
      requestedPage: page,
      perPage: 15,
      listKeys: const ['data', 'slots'],
    );
  }
}
