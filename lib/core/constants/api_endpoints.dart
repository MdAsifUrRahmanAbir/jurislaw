class ApiEndpoints {
  static const String mainDomain = "https://amisysx.com/juris_law/public";
  static const String baseUrl = "$mainDomain/api";

  // Auth
  static const String requestOtp = "/request_otp";
  static const String verifyOtp = "/verify_otp";
  static const String completeProfile = "/profile/complete";

  static const String profile = "/profile"; // Get & Post
  static const String logout = "/logout";

}
