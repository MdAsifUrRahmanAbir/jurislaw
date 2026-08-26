import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_test/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository(ref.watch(apiClientProvider));
});

class RegisterRepository {
  final ApiClient _apiClient;
  RegisterRepository(this._apiClient);

  /// POST /profile/complete only ever returns `{message}` — no updated
  /// user record — so the caller is responsible for updating the cached
  /// [AppUser] locally with the values it just submitted.
  Future<void> completeProfile({
    required String name,
    required String email,
    required String division,
    required String district,
    required String upazila,
    required String village,
    required String imagePath,
  }) async {
    await _apiClient.uploadFile(
      ApiEndpoints.completeProfile,
      imagePath,
      fileKey: 'image',
      extraData: {
        'name': name,
        'email': email,
        'division': division,
        'district': district,
        'upazila': upazila,
        'village': village,
      },
    );
  }
}
