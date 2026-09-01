import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider));
});

class HomeRepository {
  final ApiClient _apiClient;
  HomeRepository(this._apiClient);
}
