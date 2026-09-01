import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(apiClientProvider));
});

class SearchRepository {
  final ApiClient _apiClient;
  SearchRepository(this._apiClient);
}
