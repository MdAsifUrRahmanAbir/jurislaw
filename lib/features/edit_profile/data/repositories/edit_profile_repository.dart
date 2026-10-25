import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';

final editProfileRepositoryProvider = Provider<EditProfileRepository>((ref) {
  return EditProfileRepository(ref.watch(apiClientProvider));
});

class EditProfileRepository {
  final ApiClient _apiClient;

  EditProfileRepository(this._apiClient);

  /// POST /profile with `_method=PUT` (A2.3) — PHP does not parse multipart
  /// on a real PUT. Partial update: only the passed fields are sent.
  Future<void> updateProfile({
    String? name,
    String? email,
    String? division,
    String? district,
    String? upazila,
    String? village,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      '_method': 'PUT',
      'name': ?name,
      'email': ?email,
      'division': ?division,
      'district': ?district,
      'upazila': ?upazila,
      'village_mohalla': ?village,
      if (imagePath != null)
        'profile_photo': await MultipartFile.fromFile(imagePath, filename: imagePath.split(RegExp(r'[\\/]')).last),
    });
    await _apiClient.post(ApiEndpoints.clientProfile, data: formData);
  }
}
