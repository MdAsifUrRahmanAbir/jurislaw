part of 'app_pages.dart';

/// All named routes for the app — update here and it applies everywhere.
abstract class Routes {
  Routes._();

  static const splash = '/splash';
  static const onboard = '/onboard';
  static const login = '/login';
  static const register = '/register';
  static const bottomNav = '/bottom_nav';
  static const home = '/home';
  static const profile = '/profile';
  static const updateProfile = '/update_profile';
  static const settings = '/settings';
  static const changePassword = '/settings/change_password';
  static const twofaSecurity = '/settings/twofa_security';
}
