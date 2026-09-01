import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

class ProfileRepository {
  final ApiClient _apiClient;
  ProfileRepository(this._apiClient);
}
