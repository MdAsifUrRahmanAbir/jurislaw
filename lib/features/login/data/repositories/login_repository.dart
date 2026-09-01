import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository(ref.watch(apiClientProvider));
});

class LoginRepository {
  final ApiClient _apiClient;
  LoginRepository(this._apiClient);

  /// Also used for "Resend OTP" on the otp_verification screen — it's
  /// the same endpoint, just called again.
  Future<void> requestOtp(String phone) async {
    await _apiClient.post(ApiEndpoints.requestOtp, data: {'phone': phone});
  }
}
