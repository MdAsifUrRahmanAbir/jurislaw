import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/bd_locations.dart';

/// Division → district → upazila lookup from bdapis.com (public, no auth).
/// Kept off [ApiClient] on purpose: different host, and its auth / 401
/// handling must not apply here.
///
/// If bdapis.com is unreachable, falls back to the static [BdLocations]
/// list for divisions and districts; upazila lists then come back empty and
/// the UI drops back to a free-text field.
class BdGeoService {
  static const _baseUrl = 'https://bdapis.com/api/v1.2';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));

  /// GET /divisions → `data[].division`
  Future<List<String>> divisions() async {
    try {
      final res = await _dio.get('/divisions');
      final data = (res.data as Map)['data'] as List;
      final names = [
        for (final d in data)
          if (d is Map && d['division'] is String) d['division'] as String,
      ];
      return names.isEmpty ? BdLocations.divisions : names;
    } catch (_) {
      return BdLocations.divisions;
    }
  }

  /// GET /division/{name} → district name → its upazilas.
  /// One request covers both the district and upazila dropdowns.
  Future<Map<String, List<String>>> districtsOf(String division) async {
    try {
      final res = await _dio.get('/division/${Uri.encodeComponent(division)}');
      final data = (res.data as Map)['data'] as List;
      final result = <String, List<String>>{
        for (final d in data)
          if (d is Map && d['district'] is String)
            d['district'] as String: [
              for (final u in (d['upazilla'] as List? ?? const [])) u.toString(),
            ],
      };
      if (result.isNotEmpty) return result;
    } catch (_) {
      // fall through to the static list
    }
    return {for (final d in BdLocations.districtsOf(division)) d: const <String>[]};
  }
}

final bdGeoServiceProvider = Provider<BdGeoService>((ref) => BdGeoService());

/// Cached for the app's lifetime — this data never changes.
final bdDivisionsProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(bdGeoServiceProvider).divisions(),
);

/// District → upazilas for one division. Cached per division, so going back
/// to a division already picked needs no new request.
final bdDistrictsProvider = FutureProvider.family<Map<String, List<String>>, String>(
  (ref, division) => ref.watch(bdGeoServiceProvider).districtsOf(division),
);
