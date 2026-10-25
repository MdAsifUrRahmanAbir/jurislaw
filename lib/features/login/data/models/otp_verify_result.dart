import '../../../../core/utils/json_utils.dart';
import 'user_model.dart';

/// Response shape of POST /verify_otp — kept separate from [UserModel]
/// because `isProfileComplete` and the auth `token` are properties of the
/// login attempt, not of the user record itself.
class OtpVerifyResult {
  final UserModel user;
  final bool isProfileComplete;
  final String token;

  OtpVerifyResult({required this.user, required this.isProfileComplete, required this.token});

  factory OtpVerifyResult.fromJson(Map<String, dynamic> json, {String phone = ''}) {
    final userJson = Json.map(json, const ['user', 'client']) ?? {'phone': phone};
    return OtpVerifyResult(
      user: UserModel.fromJson(userJson),
      isProfileComplete: Json.boolean(json, const ['isProfileComplete', 'is_profile_complete']),
      token: Json.string(json, const ['token', 'access_token']),
    );
  }
}
