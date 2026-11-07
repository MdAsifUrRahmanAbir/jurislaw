


class ApiEndpoint {

  static String mainDomain = "https://amisysx.com/juris_law/public";
  static String baeUrl = "$mainDomain/api";

  /// ------ EndPoints
  static String sendOtpUrl = "/request_otp";
  static String verifyOtpUrl = "/verify_otp";
  static String completeProfileUrl = "/profile/complete";
  static String logOutUrl = "/logout";

  /// ------ Advocate directory (A4)
  static String advocatesUrl = "/advocates";
  static String advocateFiltersUrl = "/advocates/filters";
  static String advocateDetailsUrl(int id) => "/advocates/$id";
  static String advocateSlotsUrl(int id) => "/advocates/$id/slots";
}


