import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(apiClientProvider));
});

class SettingsRepository {
  final ApiClient _apiClient;
  SettingsRepository(this._apiClient);
}
