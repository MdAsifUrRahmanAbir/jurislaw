import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/json_utils.dart';
import '../../../login/data/models/user_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

class ProfileRepository {
  final ApiClient _apiClient;
  ProfileRepository(this._apiClient);

  /// GET /profile (A2.1) — `data.user` plus `data.profile_photo_url`.
  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.clientProfile);
    final data = Json.data(response.data);
    final userJson = Json.map(data, const ['user']) ?? data;
    return UserModel.fromJson(userJson, photoUrl: Json.stringOrNull(data, const ['profile_photo_url']));
  }
}
