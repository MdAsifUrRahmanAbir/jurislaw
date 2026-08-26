import 'user_model.dart';

/// Response shape of POST /verify_otp — kept separate from [UserModel]
/// because `isProfileComplete` and the auth `token` are properties of the
/// login attempt, not of the user record itself.
class OtpVerifyResult {
  final UserModel user;
  final bool isProfileComplete;
  final String token;

  OtpVerifyResult({required this.user, required this.isProfileComplete, required this.token});

  factory OtpVerifyResult.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResult(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      isProfileComplete: json['isProfileComplete'] == true,
      token: json['token'] as String,
    );
  }
}
