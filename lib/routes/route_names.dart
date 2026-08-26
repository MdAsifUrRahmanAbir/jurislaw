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
  static const String lawyerDetails = '/lawyers/details';
  static const String bookings = '/bookings';
  static const String intakeForm = '/intake-form';
  static const String profile = '/profile';

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
}
