import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../login/data/models/otp_verify_result.dart';

final otpRepositoryProvider = Provider<OtpRepository>((ref) {
  return OtpRepository(ref.watch(apiClientProvider));
});

class OtpRepository {
  final ApiClient _apiClient;
  OtpRepository(this._apiClient);

  Future<OtpVerifyResult> verifyOtp({required String phone, required String otp}) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    return OtpVerifyResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
