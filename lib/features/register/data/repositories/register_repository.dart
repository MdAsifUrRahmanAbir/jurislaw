import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository(ref.watch(apiClientProvider));
});

class RegisterRepository {
  final ApiClient _apiClient;
  RegisterRepository(this._apiClient);

  /// POST /profile/complete (A2.2) only ever returns `{message}` — no updated
  /// user record — so the caller is responsible for updating the cached
  /// [AppUser] locally with the values it just submitted. Upazila, village
  /// and photo are optional; empty ones are left out of the body.
  Future<void> completeProfile({
    required String name,
    required String email,
    required String division,
    required String district,
    String? upazila,
    String? village,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'division': division,
      'district': district,
      if (upazila != null && upazila.isNotEmpty) 'upazila': upazila,
      if (village != null && village.isNotEmpty) 'village_mohalla': village,
      if (imagePath != null)
        'profile_photo': await MultipartFile.fromFile(imagePath, filename: imagePath.split(RegExp(r'[\\/]')).last),
    });
    await _apiClient.post(ApiEndpoints.clientProfileComplete, data: formData);
  }
}
