import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/dashboard_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider));
});

class HomeRepository {
  final ApiClient _apiClient;
  HomeRepository(this._apiClient);

  /// GET /dashboard (A3.1)
  Future<DashboardModel> fetchDashboard() async {
    final response = await _apiClient.get(ApiEndpoints.clientDashboard);
    return DashboardModel.fromData(Json.data(response.data));
  }
}
