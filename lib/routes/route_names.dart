class RouteNames {
  RouteNames._();

  // Bootstrap / auth
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String register = '/register';

  // Shell + tabs
  static const String mainShell = '/main';
  static const String home = '/home';
  static const String lawyerList = '/lawyers';
  static const String lawyerDetails = '/lawyers/:advocateId';
  static const String bookings = '/bookings';
  static const String bookingDetails = '/bookings/:bookingId';
  static const String intakeForm = '/intake-form';
  static const String profile = '/profile';

  // Payments & live session
  static const String checkout = '/checkout/:bookingId';
  static const String paymentGateway = '/payment/gateway';
  static const String paymentStatus = '/payment/status/:transactionId';
  static const String receipts = '/payments';
  static const String sessionRoom = '/session/:bookingId';

  // Profile / settings
  static const String editProfile = '/edit_profile';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String twofaSecurity = '/settings/twofa-security';
  static const String helpSupport = '/help-support';
  static const String termsPrivacy = '/terms_privacy';
  static const String notifications = '/notifications';
  static const String search = '/search';

  // System
  static const String notFound = '/not-found';
  static const String error = '/error';
  static const String noInternet = '/no-internet';
  static const String maintenance = '/maintenance';

  // Concrete paths for the parameterised routes above.
  static String lawyerDetailsPath(String advocateId) => '/lawyers/$advocateId';
  static String bookingDetailsPath(String bookingId) => '/bookings/$bookingId';
  static String checkoutPath(String bookingId) => '/checkout/$bookingId';
  static String paymentStatusPath(String transactionId, {String? bookingId}) =>
      '/payment/status/$transactionId${bookingId == null ? '' : '?bookingId=$bookingId'}';
  static String sessionRoomPath(String bookingId) => '/session/$bookingId';
}
